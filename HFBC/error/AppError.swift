//
//  AppError.swift
//  HFBC
//
//  Created by Mike Chambers on 10/18/26.
//

import Foundation

enum AppError : HFBCError, Hashable {
	
	case network(details:ErrorDetails)
	case data(details:ErrorDetails)
	case invalidState(details:ErrorDetails)

	var name: String {
		switch self {
		case .network(_): return "AppError.network"
		case .data(_): return "AppError.data"
		case .invalidState(_): return "AppError.details"

		}
	}

	var details: ErrorDetails {
		switch self {
		case .network(let details): return details
		case .data(let details): return details
		case .invalidState(let details): return details
		}
	}
	
	var level: ErrorLevel {
		return details.level
	}
	
	var description: String {
		return details.message
	}
	
	var error: Error? {
		return details.error
	}
}
