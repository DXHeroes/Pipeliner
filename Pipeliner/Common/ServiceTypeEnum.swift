//
//  ServiceTypeEnum.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//
import SwiftUI
import Foundation
enum ServiceType: String, CaseIterable, Codable {
    case GITLAB = "GITLAB"
    case GITHUB = "GITHUB"
//    case BITBUCKET = "BITBUCKET"
    
    func urlPlaceholder() -> String {
        switch self {
        case .GITLAB:
            return "http://gitlab.com"
        case .GITHUB:
            return "http://api.github.com/repos"
//        case .BITBUCKET:
//            return "dummy"
        }
    }

    func webDescriptionLink() -> URL {
        switch self {
        case .GITLAB:
            return URL(string: "https://gitlab.com")!
        case .GITHUB:
            return URL(string: "https://github.com")!
//        case .BITBUCKET:
//            return URL(string: "dummy")!
        }
    }
    
    func tokenDescriptionLink() -> URL {
        switch self {
        case .GITLAB:
            return URL(string: "https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token")!
        case .GITHUB:
            return URL(string: "https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token")!
//        case .BITBUCKET:
//            return URL(string: "dummy")!
        }
    }
    
    func serviceName() -> String {
        switch self {
            case .GITLAB:
                return "GitLab"
            case .GITHUB:
                return "GitHub"
//            case .BITBUCKET:
//                return "BitBucket"
        }
    }
    
    func serviceIcon() -> NSImage {
        switch self {
            case .GITLAB:
                return NSImage(named: NSImage.Name("gitlab_svg_icon"))!
            case .GITHUB:
                return NSImage(named: NSImage.Name("github_svg_icon")) ?? NSImage()
//            case .BITBUCKET:
//                return NSImage(named: NSImage.Name("bitbucket_svg_icon"))!
        }
    }
}
