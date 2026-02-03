//
//  ClipboardTyper.swift
//  TypePaste
//
//  Created by Tim Haselaars on 03/02/2026.
//

import AppKit

final class ClipboardTyper {
    private let keyboardTyper = KeyboardTyper()

    func typeClipboardContents() {
        guard let rawText = NSPasteboard.general.string(forType: .string) else {
            NSSound.beep()
            return
        }

        let text = rawText.trimmingCharacters(in: .newlines)
        guard !text.isEmpty else {
            NSSound.beep()
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [keyboardTyper] in
            keyboardTyper.typeText(text)
        }
    }
}
