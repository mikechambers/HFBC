//
//  AboutView.swift
//  HFBC
//
//  Created by Mike Chambers on 10/17/26.
//


import Foundation
import SwiftUI


struct AboutView: View {

	private var version: String {
			let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
			let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
			return "Version \(v) (\(b))"
		}
	
	var body: some View {
		VStack {
			Image(nsImage: NSApp.applicationIconImage)
				.resizable()
				.frame(width: 112, height: 112)

			Text("HFBC")
				.font(.system(size: 28, weight: .bold, design: .rounded))

			Text("HF Band Conditions")
				.font(.subheadline)
				.foregroundStyle(.secondary)
			Text(version)
				.font(.caption)
				.foregroundStyle(.tertiary)
			

			Link(Config.hfbcURL.absoluteString
				.replacingOccurrences(of: "https://", with: ""), destination: Config.hfbcURL)
			Spacer()

			Text("Copyright © 2026 by Mike Chambers.")
				.multilineTextAlignment(.center).font(.subheadline)
			Spacer()

			Divider()
			Text("Solar and band data courtesy of HAMQSL.com (N0NBH)")
				.font(.caption)
				.foregroundStyle(.secondary)
	
			Link("HAMQSL.com", destination: URL(string: "https://www.hamqsl.com/solar.html")!)
		}.frame(minWidth: 300, minHeight: 300)
			.padding()
	}
}

