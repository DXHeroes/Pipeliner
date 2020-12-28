//
//  GitLabAuthType.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
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
}
