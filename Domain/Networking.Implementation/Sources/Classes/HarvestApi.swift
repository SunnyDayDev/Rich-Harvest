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

        static let projects = "\(host)projects/"

        static func project(id: Int) -> String { return "\(projects)\(id)/" }

        static func taskAssignments(byProjectId id: Int) -> String { return "\(projects)\(id)/task_assignments/" }

        static let timeEntries = "\(host)time_entries/"

    }

    enum UrlParam: String {
        case isActive = "is_active"
        case page = "page"
        case perPage = "per_page"
        case updatedSince = "updated_since"
        case clientId = "clientId"
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

        let params: [UrlParam: Any?] = [
            .isActive: isActive ? "true" : "false",
            .clientId: clientId,
            .updatedSince: updatedSince.map(DateFormatter.harvestDateFormat.string(from:)),
            .page: page,
            .perPage: perPage
        ]

        return authorized { self.request(.get, Urls.projects, parameters: params, headers: $0) }

    }

    func project(byId id: Int) -> Single<ProjectDetail> {
        return authorized { self.request(.get, Urls.project(id: id), headers: $0) }
    }

    func taskAssignments(byProjectId id: Int,
                         isActive: Bool,
                         updatedSince: Date?,
                         page: Int,
                         perPage: Int) -> Single<TaskAssignments> {

        let params: [UrlParam: Any?] = [
            .isActive: isActive ? "true" : "false",
            .updatedSince: updatedSince.map(DateFormatter.harvestDateFormat.string(from:)),
            .page: page,
            .perPage: perPage
        ]

        return authorized { self.request(.get, Urls.taskAssignments(byProjectId: id), parameters: params, headers: $0) }

    }

    func startTimer(withData data: StartTimerData) -> Single<StartTimerData> {
        return authorized { self.postJson(.post, Urls.timeEntries, data: data, headers: $0) }
    }

    private func authorized<T>(creator: @escaping (_ authHeaders: [String: String]) -> Single<T>) -> Single<T> {
        return authHeaders().flatMap { creator($0) }
    }

    private func authHeaders() -> Single<[String: String]> {
        return sessionManager.session.firstOrError()
            .map { (session: HarvestApiSession?) -> [String: String] in
                guard let session = session else {
                    throw NetworkError.sessionNotExists
                }
                return [
                    "Authorization": "Bearer \(session.personalToken)",
                    "Harvest-Account-Id": "\(session.accountId)"
                ]
            }
    }

    private func request<T: Decodable>(
        _ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [UrlParam: Any?]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil,
        logRequestData: Bool = true,
        function: String = #function,
        line: Int = #line
    ) -> Single<T> {

        return Single.deferred {

            let parameters = parameters?
                .filter { (_, value) in value != nil }
                .map { (key, value) in (key: key.rawValue, value: value!) }
                .associate { $0 }

            let requestSource = self.urlSessionManager.rx
                .request(method, url, parameters: parameters, encoding: encoding, headers: headers)

            return self.request(from: requestSource, logRequestData: logRequestData,  function: function, line: line)
                .parse(T.self)

        }

    }

    private func postJson<T: Decodable, D: Encodable>(
        _ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        data: D,
        parameters: [UrlParam: Any?]? = nil,
        headers: [String: String]? = nil,
        logRequestData: Bool = true,
        function: String = #function,
        line: Int = #line
    ) -> Single<T> {

        return Single.deferred {

            var urlComponent = URLComponents(url: try url.asURL(), resolvingAgainstBaseURL: false)!

            urlComponent.queryItems = parameters?
                .filter { (_, value) in value != nil }
                .map { (key, value) in URLQueryItem(name: key.rawValue, value: "\(value!)") }

            var request = URLRequest(url: urlComponent.url!)

            request.httpMethod = method.rawValue
            request.httpBody = try JSONEncoder.harvestJSONEncoder.encode(data)
            request.allHTTPHeaderFields = (headers ?? [:]) + [ "Content-Type": "application/json" ]

            let requestSource = self.urlSessionManager.rx.request(urlRequest: request)

            return self.request(from: requestSource, logRequestData: logRequestData,  function: function, line: line)
                .parse(T.self)

        }

    }

    private func request(from source: Observable<DataRequest>,
                         logRequestData: Bool = true,
                         function: String = #function,
                         line: Int = #line) -> Single<(HTTPURLResponse, Data)> {
        return source
            .do(onNext: {

                guard let request = $0.request else { return }

                let urlString = request.url?.absoluteString ?? "unknown url"
                Log.debug("Make request: \(urlString)")

                let dataString: String
                if logRequestData {
                    if let body = request.httpBody,
                       let stringifiedBody = String(data: body, encoding: .utf8) {
                        dataString = stringifiedBody
                    } else {
                        dataString = "unreadable data"
                    }
                }
                else { dataString = "removed from log" }

                Log.debug(
                    "REQUEST: \(request.httpMethod ?? "unknown") " +
                        "\(urlString)\n" +
                        "\tHeaders: \(request.allHTTPHeaderFields ?? [:]),\n" +
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
            return try JSONDecoder.harvestJSONDecoder.decode(type, from: data)
        }
    }

}

extension JSONDecoder {

    static let harvestJSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.harvestDateFormat)
        return decoder
    }()

}

extension JSONEncoder {

    static let harvestJSONEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        //encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601//.formatted(DateFormatter.harvestDateFormat)
        return encoder
    }()

}

extension DateFormatter {

    static var harvestDateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }

}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone? = nil) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone ?? TimeZone(abbreviation: "UTC")!
    }
}