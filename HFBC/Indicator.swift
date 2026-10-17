//
//  Indicator.swift
//  HFBC
//
//  Created by Mike Chambers on 10/15/26.
//

import SwiftUI

struct BandConditionStatusView : View {
	
	let bandCondition : BandCondition?
	
	var body: some View {
		
		Text(bandCondition?.label.uppercased() ?? "")
			.fontWeight(.semibold)
			.tracking(0.4)
			.foregroundStyle(bandCondition?.textColor ?? .secondary)
			.padding(.horizontal, 10)
			.padding(.vertical, 3)
		
			.frame(width: 64)
			.background(RoundedRectangle(cornerRadius: 6, style: .continuous)
				.fill(bandCondition?.fill ?? .gray.opacity(0.0)))
		
			.overlay(RoundedRectangle(cornerRadius: 6, style: .continuous)
					.strokeBorder(bandCondition?.stroke ?? .clear, lineWidth: 1))
			.animation(.easeInOut(duration: 0.4), value: bandCondition)
	}
}

extension BandCondition {
	
	var label:String {
		switch self {
		case .good:
			return "good"
		case .fair:
			return "fair"
		case .poor:
			return "poor"
		}
	}
	
	var fill: Color {
		switch self {
		case .good: Color(hex: 0xE3F4E8)
		case .fair: Color(hex: 0xFDF1CF)
		case .poor: Color(hex: 0xFBE0DD)
		}
	}
	var textColor: Color {
		switch self {
		case .good: Color(hex: 0x17603A)
		case .fair: Color(hex: 0x6B4A00)
		case .poor: Color(hex: 0x8F1D16)
		}
	}
	var stroke: Color {
		switch self {
		case .good: Color(hex: 0xB5DDC2)
		case .fair: Color(hex: 0xF0D98F)
		case .poor: Color(hex: 0xF0B4AD)
		}
	}
}
