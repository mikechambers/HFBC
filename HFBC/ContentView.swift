//
//  ContentView.swift
//  HFBC
//
//  Created by Mike Chambers on 10/15/26.
//

import SwiftUI

struct ContentView: View {
	@Environment(DataManager.self) private var dataManager
	
	
    var body: some View {
        VStack {
			/*
			HStack {
				Text("HF Band Conditions")
					.font(.largeTitle.bold())
				Spacer()
				Text("02:20 UTC : 16 Oct 2026")
					.font(.title2.bold())
			}
			Divider()
			 */
			Grid {
				GridRow {
					Text("")
						.font(.caption.weight(.semibold))
						.tracking(1)
						.foregroundStyle(.secondary)
					//Text("DAY").gridColumnAlignment(.center).font(.title2.bold())
					//Text("NIGHT").gridColumnAlignment(.center).font(.title2.bold())
					Image(systemName: "sun.max")
						.font(.title3.weight(.bold))
						.foregroundStyle(.orange)
			
						.help("Day")
						.accessibilityLabel("Day")

					Image(systemName: "moon")
						.font(.title3.weight(.bold))
						.foregroundStyle(.indigo)
					
						.help("Night")
						.accessibilityLabel("Night")
				}
				
				Divider()
				GridRow {
					BandLabelView(band: .b80_40)
						.gridColumnAlignment(.leading)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b80_40]?.day)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b80_40]?.night)
				}
				Divider()
				GridRow {
					BandLabelView(band: .b30_20)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b30_20]?.day)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b30_20]?.night)
				}
				Divider()
				GridRow {
					BandLabelView(band: .b17_15)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b17_15]?.day)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b17_15]?.night)
				}
				Divider()
				GridRow {
					BandLabelView(band: .b12_10)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b12_10]?.day)
					BandConditionStatusView(bandCondition: dataManager.statuses[.b12_10]?.night)
				}
			}
			.padding(.horizontal, 20)
			.padding(.vertical, 12)
			.background(.background, in: .rect(cornerRadius: 12))
			Spacer()
        }
        //.padding()
		//Text("Data: HAMQSL.com")
    }
}

#Preview {
    ContentView()
}
