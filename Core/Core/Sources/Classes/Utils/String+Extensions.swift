//
// Created by Александр Цикин on 2018-09-21.
//

import Foundation

public extension Data {

    var htmlToAttributedString: NSAttributedString? {

        do {

            return try NSAttributedString(
                data: self,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )

        } catch {

            print("error:", error)
            return  nil

        }

    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

}

public extension String {

    var htmlToAttributedString: NSAttributedString? {
        return Data(utf8).htmlToAttributedString
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst().lowercased()
    }

    func capitalizingFirstLetterEachWord() -> String {
        return components(separatedBy: .whitespaces)
            .map { $0.capitalizingFirstLetter() }
            .joined(separator: " ")
    }

    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }

}