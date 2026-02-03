//
//  HotKeyManager.swift
//  TypePaste
//
//  Created by Tim Haselaars on 03/02/2026.
//

import Carbon
import Foundation

final class HotKeyManager {
    var onHotKeyPressed: (() -> Void)?

    private var hotKeyRef: EventHotKeyRef?
    private var handlerRef: EventHandlerRef?

    init(keyCode: Int, modifiers: UInt32) {
        registerHotKey(keyCode: keyCode, modifiers: modifiers)
    }

    deinit {
        unregisterHotKey()
    }

    func update(keyCode: Int, modifiers: UInt32) {
        unregisterHotKey()
        registerHotKey(keyCode: keyCode, modifiers: modifiers)
    }

    private func registerHotKey(keyCode: Int, modifiers: UInt32) {
        var hotKeyID = EventHotKeyID(signature: "TPST".fourCharCode, id: 1)

        let status = RegisterEventHotKey(
            UInt32(keyCode),
            modifiers,
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &hotKeyRef
        )
        guard status == noErr else { return }

        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        InstallEventHandler(
            GetEventDispatcherTarget(),
            HotKeyManager.hotKeyHandler,
            1,
            &eventType,
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            &handlerRef
        )
    }

    private func unregisterHotKey() {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
        if let handlerRef {
            RemoveEventHandler(handlerRef)
            self.handlerRef = nil
        }
    }

    private func handleHotKeyPressed() {
        onHotKeyPressed?()
    }

    private static let hotKeyHandler: EventHandlerUPP = { _, _, userData in
        guard let userData else { return noErr }
        let manager = Unmanaged<HotKeyManager>.fromOpaque(userData).takeUnretainedValue()
        manager.handleHotKeyPressed()
        return noErr
    }
}

private extension String {
    var fourCharCode: FourCharCode {
        var result: FourCharCode = 0
        for scalar in unicodeScalars.prefix(4) {
            result = (result << 8) + FourCharCode(scalar.value)
        }
        return result
    }
}
