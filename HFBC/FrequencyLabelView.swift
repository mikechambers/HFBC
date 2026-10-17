//
//  FrequencyView.swift
//  HFBC
//
//  Created by Mike Chambers on 10/15/26.
//

import SwiftUI

struct FrequencyLabelView : View {
	
	let startFrequency: String
	let endFrequency: String
	
	var body: some View {
		Text("\(startFrequency) – \(endFrequency) MHz").font(.body.italic())
	}
}
