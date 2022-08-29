//
//  Logger.swift
//  Pipeliner
//
//  Created by Michal Sverak on 24.08.2022.
//

import Foundation

final class NetworkingLogger {

    static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }

    static func log(_ error: Error) {
        #if DEBUG
        print(error)
        #endif
    }

    static func logRequest(_ request: URLRequest, config: URLSessionConfiguration) {
        log("⬆️ REQUEST")
        log("URL: \(String(describing: request.url?.absoluteString))")
        log("METHOD: \(request.httpMethod ?? "NO-HTTP-METHOD-SET")")
        log("HEADERS:\n   \(String(describing: request.allHTTPHeaderFields))\n")

        if let body = request.httpBody {
            if let encodedString = String(data: body, encoding: .utf8) {
                log("HTTP BODY:\n   \(encodedString)")
            } else {
                log("HTTP BODY:\n   \(body)")
            }
        } else {
            log("HTTP BODY:\n   is empty")
        }
    }

    static func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?) {
        log("⬇️ RESPONSE")
        if let data = data, let encodedString = String(data: data, encoding: .utf8), !encodedString.isEmpty {
            log("Response data:\n\(encodedString)")
        }
        let statusIcons = [
            1: "ℹ️",
            2: "✅",
            3: "⤴️",
            4: "⛔️",
            5: "❌"
        ]

        if let response = response {
            var responseString = "Response status code: \(response.statusCode)"
            let iconNumber = Int(floor(Double(response.statusCode) / 100.0))
            if let iconString = statusIcons[iconNumber] {
                responseString = "\(iconString) " + responseString + "\n"
            }
            log(responseString)
        }
        if let error = error {
            log("Response Error: \( error.localizedDescription)")
        }
    }
}
