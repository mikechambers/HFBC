//
//  BandLabelView.swift
//  HFBC
//
//  Created by Mike Chambers on 10/15/26.
//

import SwiftUI

struct BandLabelView : View {
	
	let band: Band
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("\(band.bandInfo.startBand)m – \(band.bandInfo.endBand)m").font(.title3.bold())
			//Text("\(band.bandInfo.startFrequency) – \(band.bandInfo.endFrequency) MHz").font(.body.italic())
			Text("\(band.bandInfo.startFrequency) – \(band.bandInfo.endFrequency) MHz")
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.monospacedDigit()
		}
	}
}
