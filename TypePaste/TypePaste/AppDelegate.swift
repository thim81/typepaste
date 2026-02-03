//
//  AppDelegate.swift
//  TypePaste
//
//  Created by Tim Haselaars on 03/02/2026.
//

import AppKit
import ApplicationServices
import Carbon

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let clipboardTyper = ClipboardTyper()
    private var hotKeyManager: HotKeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        requestAccessibilityPermission()
        NSApp.setActivationPolicy(.accessory)
        setUpStatusItem()
        setUpHotKey()
    }

    func applicationWillTerminate(_ notification: Notification) {
        hotKeyManager = nil
    }

    private func setUpStatusItem() {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "TypePaste")

        let menu = NSMenu()
        menu.addItem(NSMenuItem(
            title: "Type Clipboard (⌘1)",
            action: #selector(typeClipboard),
            keyEquivalent: "1"
        ))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(
            title: "Settings…",
            action: #selector(openSettings),
            keyEquivalent: ","
        ))
        menu.addItem(NSMenuItem(
            title: "Quit TypePaste",
            action: #selector(quitApp),
            keyEquivalent: "q"
        ))
        statusItem.menu = menu

        self.statusItem = statusItem
    }

    private func setUpHotKey() {
        hotKeyManager = HotKeyManager(keyCode: kVK_ANSI_1, modifiers: UInt32(cmdKey))
        hotKeyManager?.onHotKeyPressed = { [weak self] in
            self?.typeClipboard()
        }
    }

    private func requestAccessibilityPermission() {
        let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options: NSDictionary = [promptKey: true]
        _ = AXIsProcessTrustedWithOptions(options)
    }

    @objc private func typeClipboard() {
        clipboardTyper.typeClipboardContents()
    }

    @objc private func openSettings() {
        // Use string selector to avoid compile issues on older SDKs.
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
