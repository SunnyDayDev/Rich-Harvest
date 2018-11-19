//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation

import RxSwift
import RxAlamofire
import Alamofire

import RichHarvest_Core_Core
import RichHarvest_Domain_Networking_Api

class HarvestApiImplementation: HarvestApi {

    struct Urls {
        static let host = "https://api.harvestapp.com/v2/"
        static let projects = "\(host)/projects/"
        static func project(id: Int) -> String { return "\(project)/\(id)" }
    }

    private let sessionManager: HarvestApiSessionManager

    private let urlSessionManager: SessionManager

    init(sessionManager: HarvestApiSessionManager, urlSessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.urlSessionManager = urlSessionManager
    }

    func projects(isActive: Bool,
                  clientId: String?,
                  updatedSince: Date?,
                  page: Int,
                  perPage: Int) -> Single<Projects> {
        return authorized { self.request(.get, Urls.projects, headers: $0) }
    }

    func project(byId id: Int) -> Single<ProjectDetail> {
        return authorized { self.request(.get, Urls.project(id: id), headers: $0) }
    }

    func authorized<T>(creator: @escaping (_ authHeaders: [String: String]) -> Single<T>) -> Single<T> {
        return authHeaders().flatMap { creator($0) }
    }

    func authHeaders() -> Single<[String: String]> {
        return Single.just([
            "Autorization": "Bearer XXX",
            "Harvest-Account-Id": "XXX"
        ])
    }

    private func request<T: Decodable>(_ method: Alamofire.HTTPMethod,
                         _ url: URLConvertible,
                         parameters: [String: Any]? = nil,
                         encoding: ParameterEncoding = URLEncoding.default,
                         headers: [String: String]? = nil,
                         logRequestData: Bool = true,
                         function: String = #function,
                         line: Int = #line
    ) -> Single<T> {
        let requestSource = urlSessionManager.rx
            .request(method, url, parameters: parameters, encoding: encoding, headers: headers)
        return request(from: requestSource, logRequestData: logRequestData,  function: function, line: line)
            .parse(T.self)
    }

    private func request(from source: Observable<DataRequest>,
                         logRequestData: Bool = true,
                         function: String = #function,
                         line: Int = #line) -> Single<(HTTPURLResponse, Data)> {
        return source
            .do(onNext: {

                guard let request = $0.request else { return }

                let dataString: String
                if logRequestData { dataString = String(data: request.httpBody!, encoding: .utf8)! }
                else { dataString = "removed from log" }

                Log.debug(
                    "REQUEST: \(request.httpMethod!) " +
                        "\(request.url!)\n" +
                        "\tHeaders: \(request.allHTTPHeaderFields!),\n" +
                        "\tData: \(dataString)"
                )

            })
            .validate(statusCode: 200..<400)
            .responseJSON()
            .firstOrError()
            .map { ($0.response!, $0.data!) }
            .logResponse(function, line)
            .catchError(generalizeErrorForSingle(error:))
    }

    private func generalizeErrorForSingle<T>(error: Error) -> Single<T> {
        return Single.error(generalizeError(error))
    }

    private func generalizeError(_ error: Error) -> Error {

        Log.error("Generalize error: \(error)")

        switch error {

        case let error as AFError:

            switch error {

            case let .responseValidationFailed(reason):
                switch reason {

                case let .unacceptableStatusCode(code):
                    return NetworkError.http(code: code)

                default: break

                }

            default: break

            }

        default: break

        }

        return error

    }

}

private extension PrimitiveSequence where Trait == SingleTrait, Element == (HTTPURLResponse, Data) {

    func logResponse(_ function: String = #function,
                     _ line: Int = #line) -> Single<(HTTPURLResponse, Data)> {

        return self.do(
            onSuccess: { (res: HTTPURLResponse, data: Data) in

                let readableData = String(data: data, encoding: .utf8)!

                let logLine = "RESPONSE: \(res.url!): " +
                    "\(res.statusCode):\n" +
                    "\tHeaders: \(res.allHeaderFields)\n" +
                    "\tData: \(readableData)"

                Log.debug(logLine, #file, function, line: line)

            },
            onError: { e in Log.error(e, #file, function, line: line) }
        )

    }

    func parse<T: Decodable>(_ type: T.Type) -> Single<T> {
        return map { (response: HTTPURLResponse, data: Data) in
            return try JSONDecoder().decode(type, from: data)
        }
    }

}