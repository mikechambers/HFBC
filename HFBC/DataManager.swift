//
//  DataManager.swift
//  HFBC
//
//  Created by Mike Chambers on 10/16/26.
//

import AppKit
import Foundation
import SWXMLHash
import SwiftUI
import OSLog

@MainActor
@Observable
final class DataManager {
	
	@ObservationIgnored var timer:Timer? = nil
	let interval:TimeInterval = 15 * 60.0
	
	var statuses:[Band:BandStatus] = [:]
	
	let dataURL:URL = URL(string: "https://www.hamqsl.com/solarxml.php")!
	
	init() {
		
		timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {[weak self] _ in
			Task { @MainActor in
				do {
					guard let self else {
						Logger.app.critical("Couldn't unwrap self in DataManager. Aborting data loading.")
						return
					}
					
					let s = try await self.loadUTF8()
					try self.parseXML(xml: s)
				} catch {
	
					Logger.app.error("Failed to load and parse XML: \(error)")
				}
			}
		}
		
		timer?.fire()
	}
	
	func reloadData() {
		timer?.fire()
	}
	
	func loadUTF8() async throws -> String {
		
		do {
			let (data, _) = try await URLSession.shared.data(from: dataURL)
			
			
			guard let s = String(data: data, encoding: .utf8) else {
				throw AppError.data(
					details: ErrorDetails(level: .critical,
										  message: "Could not decode data as UTF-8."))
			}

			return s
			
		} catch {
			throw AppError.network(
				details: ErrorDetails(
					level: .warning,
					message: "Could not load bandwidth condition data.", error: error))
		}
	}
	
	func parseXML(xml:String) throws {
		
		let xml = XMLHash.config {
					  config in
			config.detectParsingErrors = true
				  }.parse(xml)


		if case .parsingError(let error) = xml {
			throw AppError.data(
				details: ErrorDetails(
					level: .critical,
					message: "XML Parsing Failed. Invalid XML data syntax",
					error: error)
			)
		}
		
		let bandIndexer = xml["solar"]["solardata"]["calculatedconditions"]["band"]
		
		if case .xmlError(let error) = bandIndexer {
			throw AppError.data(
				details: ErrorDetails(
					level: .critical,
					message: "Required XML are missing.",
					error: error)
			)
		}
		
		if bandIndexer.all.isEmpty {
			Logger.data.warning("calculatedconditions xml node is empty. Skipping parsing.")
			return
		}
		
		var parsed: [Band: BandStatus] = [:]
		
		for elem in bandIndexer.all {

			guard let bandName = elem.element?.attribute(by: "name")?.text else {
				Logger.data.error("calculatedconditions element missing name attribute. Skipping band.")
				continue
			}
			
			guard let bandTime = elem.element?.attribute(by: "time")?.text else {
				Logger.data.error("calculatedconditions element missing time attribute Skipping band.")
				continue
			}
			
			guard let condition = elem.element?.text else {
				Logger.data.error("calculatedconditions element missing data (condition). Skipping band.")
				continue
			}
			
			guard let band = Band(s: bandName) else {
				Logger.data.info("Data contained an unknown band: \(bandName)")
				continue
			}
			
			guard let period = DayPeriod(s: bandTime) else {
				Logger.data.info("Data contained an unknown period: \(bandTime)")
				continue
			}
			guard let condition = BandCondition(s: condition) else {
				Logger.data.info("Data contained an unknown condition: \(condition)")
				continue
			}
			
			if parsed[band] == nil {
				parsed[band] = BandStatus()
			}
		
			
			if period == .day {
				parsed[band]?.day = condition
			} else {
				parsed[band]?.night = condition
			}
			
			
			//print("Band: \(bandStatus.band.bandInfo.startBand) | Period: \(bandStatus.period) | Status: \(bandStatus.condition)")
		}
		
		if !parsed.isEmpty {
			statuses = parsed
		}
		
	}
}

struct BandStatus {
	var day:BandCondition?
	var night:BandCondition?
}



enum Band {
	case b80_40
	case b30_20
	case b17_15
	case b12_10
	
	init?(s:String) {
		switch s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
			case "80m-40m": self = .b80_40
			case "30m-20m": self = .b30_20
			case "17m-15m": self = .b17_15
			case "12m-10m": self = .b12_10
			default : return nil
		}
	}
	
	var bandInfo : BandInfo {
		switch self {
		case .b80_40: return BandInfo(
			startBand: "80", endBand: "40", startFrequency: "3.5", endFrequency: "7.3")
		case .b30_20: return BandInfo(
			startBand: "30", endBand: "20", startFrequency: "10.1", endFrequency: "14.35")
		case .b17_15: return BandInfo(
			startBand: "17", endBand: "15", startFrequency: "18.068", endFrequency: "21.45")
		case .b12_10: return BandInfo(
			startBand: "12", endBand: "10", startFrequency: "24.89", endFrequency: "29.7")
		}
	}
}


struct BandInfo {
	let startBand:String
	let endBand:String
	let startFrequency:String
	let endFrequency:String
}

enum DayPeriod {
	case day
	case night
	
	init?(s:String) {

		switch s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
			case "day": self = .day
			case "night": self = .night
			default : return nil
		}
	}
}

enum BandCondition {
	case good
	case fair
	case poor
	
	init?(s:String) {

		switch s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
			case "good": self = .good
			case "fair": self = .fair
			case "poor": self = .poor
			default : return nil
		}
	}
}

