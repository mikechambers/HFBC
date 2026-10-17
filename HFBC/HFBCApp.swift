//
//  HFBCApp.swift
//  HFBC
//
//  Created by Mike Chambers on 10/15/26.
//

import SwiftUI

@main
struct HFBCApp: App {
	
	@State var dataManager: DataManager = .init()
	
	@AppStorage("alwaysOnTop") private var alwaysOnTop = false
	
    var body: some Scene {
        WindowGroup {
			ContentView().environment(dataManager)
				.padding()
				.frame(width: 400)
				.fixedSize(horizontal: false, vertical: true)
				.preferredColorScheme(.light)
				
				//.frame(maxWidth: 480, maxHeight: 480)
        }
		.windowLevel(alwaysOnTop ? .floating : .normal)
		.windowResizability(.contentSize)
		.commands {
			CommandGroup(after: .windowArrangement) {
				Toggle("Always on Top", isOn: $alwaysOnTop)
					.keyboardShortcut("t", modifiers: [.command, .option])
			}
		}
		
    }
}
