//
//  ContentView.swift
//  HFBC
//
//  Created by Mike Chambers on 10/15/26.
//

import SwiftUI

struct ContentView: View {
	@Environment(DataManager.self) private var dataManager
	@Environment(\.colorScheme) private var scheme
	
    var body: some View {
        VStack {

			Grid {
				GridRow {
					Text("")
						.font(.caption.weight(.semibold))
						.tracking(1)
						.foregroundStyle(.secondary)
					Image(systemName: "sun.max")
						.font(.title3.weight(.bold))
						.foregroundStyle(Color(hex: scheme == .dark ? 0xF5B44A : 0xE8890C))
						.help("Day")
						.accessibilityLabel("Day")

					Image(systemName: "moon")
						.font(.title3.weight(.bold))
						.foregroundStyle(Color(hex: scheme == .dark ? 0x9EA8FF : 0x5B4FD1))
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
