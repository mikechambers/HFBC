//
//  Indicator.swift
//  HFBC
//
//  Created by Mike Chambers on 10/15/26.
//

import SwiftUI

struct BandConditionStatusView : View {
	@Environment(\.colorScheme) private var scheme
	
	let bandCondition : BandCondition?
	
	var body: some View {
		
		Text(bandCondition?.label.uppercased() ?? "")
			.fontWeight(.semibold)
			.tracking(0.4)
			.foregroundStyle(bandCondition?.textColor(scheme) ?? .secondary)
			.padding(.horizontal, 10)
			.padding(.vertical, 3)
		
			.frame(width: 64)
			.background(RoundedRectangle(cornerRadius: 6, style: .continuous)
				.fill(bandCondition?.fill(scheme) ?? .gray.opacity(0.0)))
		
			.overlay(RoundedRectangle(cornerRadius: 6, style: .continuous)
					.strokeBorder(bandCondition?.stroke(scheme) ?? .clear, lineWidth: 1))
			.animation(.easeInOut(duration: 0.4), value: bandCondition)
	}
}
extension BandCondition {
	var label: String {
		switch self {
		case .good: "good"
		case .fair: "fair"
		case .poor: "poor"
		}
	}

	func fill(_ scheme: ColorScheme) -> Color {
		let dark = scheme == .dark
		switch self {
		case .good: return Color(hex: dark ? 0x1F3A2B : 0xE3F4E8)
		case .fair: return Color(hex: dark ? 0x3D3217 : 0xFDF1CF)
		case .poor: return Color(hex: dark ? 0x4A2220 : 0xFBE0DD)
		}
	}

	func textColor(_ scheme: ColorScheme) -> Color {
		let dark = scheme == .dark
		switch self {
		case .good: return Color(hex: dark ? 0x7DDCA5 : 0x17603A)
		case .fair: return Color(hex: dark ? 0xF5CD6A : 0x6B4A00)
		case .poor: return Color(hex: dark ? 0xFF9A90 : 0x8F1D16)
		}
	}

	func stroke(_ scheme: ColorScheme) -> Color {
		let dark = scheme == .dark
		switch self {
		case .good: return Color(hex: dark ? 0x2F5A43 : 0xB5DDC2)
		case .fair: return Color(hex: dark ? 0x5E4D22 : 0xF0D98F)
		case .poor: return Color(hex: dark ? 0x703532 : 0xF0B4AD)
		}
	}
}
