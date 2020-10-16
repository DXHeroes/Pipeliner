//
//  ServiceTypeEnum.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
enum ServiceType: String, CaseIterable {
    case GITLAB = "GITLAB"
    case GITHUB = "GITHUB"
    
    func urlPlaceholder() -> String {
        switch self {
        case .GITLAB:
            return "http://gitlab.com"
        case .GITHUB:
            return "http://api.github.com/repos"
        }
    }
    
    func tokenDescriptionLink() -> URL {
        switch self {
        case .GITLAB:
            return URL(string: "https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token")!
        case .GITHUB:
            return URL(string: "https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token")!
        }
    }
}
