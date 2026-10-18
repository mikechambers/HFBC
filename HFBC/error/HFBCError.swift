//
//  HFBCError.swift
//  HFBC
//
//  Created by Mike Chambers on 10/18/26.
//


import Foundation
import SwiftUI

enum ErrorLevel: UInt32, Comparable, Hashable {
	case information = 0
	case warning = 1
	case critical = 2
	case fatal = 3
	
	var color: Color {
		switch self {
		case .information: return .primary
		case .warning:     return .yellow
		case .critical:    return .orange
		case .fatal:       return .red
		}
	}
	
	static func < (lhs: ErrorLevel, rhs: ErrorLevel) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}


protocol HFBCError : Error {
	var level : ErrorLevel { get }
	var description: String { get }
	var error: Error? { get }
	var name: String { get }
}


struct ErrorDetails: Hashable {
	let id = UUID()
	var level: ErrorLevel
	var message: String
	var error: Error?

	static func == (lhs: ErrorDetails, rhs: ErrorDetails) -> Bool {
		return lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

