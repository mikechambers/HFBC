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
	
	@NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	
    var body: some Scene {
        WindowGroup {
			ContentView().environment(dataManager)
				.padding()
				.frame(width: 400)
				.fixedSize(horizontal: false, vertical: true)
				//.preferredColorScheme(.dark)
				
				//.frame(maxWidth: 480, maxHeight: 480)
        }
		.windowLevel(alwaysOnTop ? .floating : .normal)
		.windowResizability(.contentSize)
		.commands {
			CommandGroup(after: .windowArrangement) {
				Toggle("Always on Top", isOn: $alwaysOnTop)
					.keyboardShortcut("t", modifiers: [.command, .option])
			}
			CommandGroup(replacing: CommandGroupPlacement.appInfo) {
				Button(action: {
					appDelegate.showAboutPanel()
				}) {
					Text("About HFBC")
				}
			}
		}
		
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
	private var aboutBoxWindowController: NSWindowController?

	func showAboutPanel() {
		if aboutBoxWindowController == nil {
			aboutBoxWindowController = createAboutBoxWindowController()
		}

		aboutBoxWindowController?.showWindow(nil)
	}

	private func createAboutBoxWindowController() -> NSWindowController {
		let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled]
		let window = NSWindow()
		window.styleMask = styleMask
		window.title = "About HFBC"
		window.contentView = NSHostingView(rootView: AboutView())

		window.center()

		return NSWindowController(window: window)
	}
}
