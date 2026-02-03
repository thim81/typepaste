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
        guard let text = NSPasteboard.general.string(forType: .string), !text.isEmpty else {
            NSSound.beep()
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [keyboardTyper] in
            keyboardTyper.typeText(text)
        }
    }
}
