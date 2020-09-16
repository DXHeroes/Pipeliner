//
//  Response.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
public struct PipelineResult: Identifiable, Hashable {
    public let id: Int
    public let ref: String
    public let status: PipelineStatus
    public let duration: String
    public let age: String
    public let url: String
    public let repositoryName: String
}
