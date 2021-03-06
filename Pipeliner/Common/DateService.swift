//
//  DateService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
struct DateService {
    func parse(date: String, isWithFractionalSeconds: Bool = false) throws -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = isWithFractionalSeconds ? [.withFractionalSeconds, .withInternetDateTime] : [.withInternetDateTime]
        guard let result = dateFormatter.date(from: date) else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            guard let secondTry = dateFormatter.date(from: date) else {
                throw ApiError.invalidDate
            }
            return secondTry
        }
        return result
    }
    func format(from: Date, to: Date) throws -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        guard let result = formatter.string(from: from.distance(to: to)) else {
            throw ApiError.invalidDate
        }
        return result
    }
}
