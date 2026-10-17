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

@MainActor
@Observable
final class DataManager {
	
	@ObservationIgnored var timer:Timer? = nil
	let interval:TimeInterval = 60 * 60.0 //5 minutes
	
	var statuses:[Band:BandStatus] = [:]
	
	let dataURL:URL
	
	init() {
		
		dataURL = URL(string: "https://www.hamqsl.com/solarxml.php")!
		
		timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {[weak self] _ in
			Task { @MainActor in
				await self?.loadData()
			}
		}
		
		timer?.fire()
	}
	
	func loadData() async {
		
		do {
			let (data, _) = try await URLSession.shared.data(from: dataURL)
			let xml = String(data: data, encoding: .utf8) ?? "Failed to decode"

			parseXML(xml:xml)
			
		} catch {
			print("Network request failed: \(error.localizedDescription)")
		}
	}
	
	func parseXML(xml:String) {
		let xml = XMLHash.parse(xml)
		
		
		var parsed: [Band: BandStatus] = [:]
		
		for elem in xml["solar"]["solardata"]["calculatedconditions"]["band"].all {

			let bandName = elem.element?.attribute(by: "name")?.text ?? "Unknown"
			let bandTime = elem.element?.attribute(by: "time")?.text ?? "Unknown"
			
			// 2. Grab the tag's inner status text
			let condition = elem.element?.text ?? ""
			
			guard let band = Band(s: bandName) else { continue }
			guard let period = DayPeriod(s: bandTime) else { continue }
			guard let condition = BandCondition(s: condition) else { continue }
			
			
			//let bandStatus = BandStatus(band: band, period: period, condition: condition)
			
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

