//
//  DateService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
struct DateService {
    func parse(date: String) throws -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        guard let firstTry = dateFormatter.date(from: date) else {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
            guard let secondTry = dateFormatter.date(from: date) else {
                throw ApiError.invalidDate
            }
            return secondTry
        }
        return firstTry
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
