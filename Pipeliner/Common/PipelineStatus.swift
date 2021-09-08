//
//  GitLabAuthType.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
import SwiftUI

public enum PipelineStatus: String, Decodable {
    case SUCCESS = "success"
    case FAILED = "failed"
	case CREATED = "created"
	case WAITING_FOR_RESOURCE = "waiting_for_resource"
	case PREPARING = "preparing"
	case PENDING = "pending"
	case RUNNING = "running"
	case CANCELED = "canceled"
	case SKIPPED = "skipped"
	case MANUAL = "manual"
	case SCHEDULED = "scheduled"
    
    public func readableTitle() -> String {
        switch self {
        case .WAITING_FOR_RESOURCE:
            return "Waiting for resource"
        default:
            return self.rawValue.capitalized
        }
    }
    
    public func requiresTitle() -> Bool {
        return self != .SUCCESS &&
            self != .FAILED
    }
    
    public func icon() -> some View {
        var imageName: String
        var color: Color
        switch self {
        case .SUCCESS:
            imageName = "checkmark"
            color = Color("lightteal")
        case .FAILED:
            imageName = "xmark"
            color = Color("error")
        case .MANUAL:
            imageName = "gear"
            color = Color("warning")
        case .RUNNING, .PENDING, .SCHEDULED:
            imageName = "hourglass"
            color = .white
        default:
            imageName = "questionmark"
            color = .gray
        }
        return Image(systemName: imageName).font(.title).foregroundColor(color)
    }
}
