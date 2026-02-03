//
//  KeyboardTyper.swift
//  TypePaste
//
//  Created by Tim Haselaars on 03/02/2026.
//

import ApplicationServices
import Foundation

final class KeyboardTyper {
    private let eventSource = CGEventSource(stateID: .combinedSessionState)
    private let delayPerCharacter: TimeInterval = 0.04

    func typeText(_ text: String) {
        for character in text {
            typeCharacter(character)
            Thread.sleep(forTimeInterval: delayPerCharacter)
        }
    }

    private func typeCharacter(_ character: Character) {
        guard let eventSource else { return }
        let string = String(character)
        let unicodeScalars = Array(string.utf16)

        if let keyDown = CGEvent(keyboardEventSource: eventSource, virtualKey: 0, keyDown: true) {
            keyDown.keyboardSetUnicodeString(stringLength: unicodeScalars.count, unicodeString: unicodeScalars)
            keyDown.post(tap: .cghidEventTap)
        }

        if let keyUp = CGEvent(keyboardEventSource: eventSource, virtualKey: 0, keyDown: false) {
            keyUp.keyboardSetUnicodeString(stringLength: unicodeScalars.count, unicodeString: unicodeScalars)
            keyUp.post(tap: .cghidEventTap)
        }
    }
}
