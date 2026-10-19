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
		
		HStack {
			if dataManager.isLoading {
				ProgressView().controlSize(.small).frame(alignment: .leading)
			} else {
				Color.clear
					.frame(width: 16, height: 16)
			}
			Spacer()
			TimelineView(.periodic(from: .now, by: 30)) { context in
				let text = updatedText(for: dataManager.lastUpdated, now: context.date)

				Text(text)
					.font(.caption)
					.foregroundStyle(.secondary)
					.contentTransition(.opacity)
					.animation(.easeInOut(duration: 0.4), value: text)
			}
		}
		
    }
	
	private let relativeFormatter: RelativeDateTimeFormatter = {
		let f = RelativeDateTimeFormatter()
		f.unitsStyle = .full
		return f
	}()

	func updatedText(for date: Date?, now: Date) -> String {
		guard let date else { return "Not updated yet" }
		if now.timeIntervalSince(date) < 60 { return "Updated just now" }
		return "Updated " + relativeFormatter.localizedString(for: date, relativeTo: now)
	}
}

#Preview {
    ContentView()
}
