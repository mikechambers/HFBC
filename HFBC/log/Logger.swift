//
//  Logger.swift
//  HFBC
//
//  Created by Mike Chambers on 10/18/26.
//


import Foundation
import OSLog

nonisolated extension Logger {
	private static var subsystem = Bundle.main.bundleIdentifier!
	static let app =  Logger(subsystem:subsystem, category:"app")
	static let data =  Logger(subsystem:subsystem, category:"data")
}
