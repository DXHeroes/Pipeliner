//
//  ServiceTypeEnum.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import SwiftUI

enum ServiceType: String, CaseIterable, Codable {
    case gitlab = "GITLAB"
    case github = "GITHUB"
    
    func urlPlaceholder() -> String {
        switch self {
        case .gitlab:
            return "http://gitlab.com"
        case .github:
            return "http://api.github.com/repos"
        }
    }

    func webDescriptionLink() -> URL {
        switch self {
        case .gitlab:
            return URL(string: "https://gitlab.com")!
        case .github:
            return URL(string: "https://github.com")!
        }
    }
    
    func tokenDescriptionLink() -> URL {
        switch self {
        case .gitlab:
            return URL(string: "https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token")!
        case .github:
            return URL(string: "https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token")!
        }
    }
    
    func serviceName() -> String {
        switch self {
            case .gitlab:
                return "GitLab"
            case .github:
                return "GitHub"
        }
    }

    #warning("Get rid of NSImage")
    func serviceIcon() -> NSImage {
        switch self {
        case .gitlab:
            return NSImage(named: NSImage.Name("gitlab_svg_icon"))!
        case .github:
            return NSImage(named: NSImage.Name("github_svg_icon"))!
        }
    }

    #warning("Rename to serviceIcon")
    func servicePickerIcon() -> Image {
        switch self {
        case .gitlab:
            return Image("gitlab_svg_icon")
        case .github:
            return Image("github_icon")
        }
    }
}
