//
//  color.swift
//  HFBC
//
//  Created by Mike Chambers on 10/16/26.
//

import SwiftUI

extension Color {
	
	init(hex: UInt32, opacity: Double = 1) {
		self.init(
			.sRGB,
			red:   Double((hex >> 16) & 0xFF) / 255,
			green: Double((hex >> 8)  & 0xFF) / 255,
			blue:  Double( hex        & 0xFF) / 255,
			opacity: opacity
		)
	}

	
	init(light: UInt32, dark: UInt32) {
		self.init(nsColor: NSColor(name: nil) { appearance in
			let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
			let hex = isDark ? dark : light
			return NSColor(
				srgbRed: CGFloat((hex >> 16) & 0xFF) / 255,
				green:   CGFloat((hex >> 8)  & 0xFF) / 255,
				blue:    CGFloat( hex        & 0xFF) / 255,
				alpha:   1)
		})
	}
}
