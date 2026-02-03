//
//  ContentView.swift
//  TypePaste
//
//  Created by Tim Haselaars on 03/02/2026.
//

import Carbon
import SwiftUI

struct ContentView: View {
    @AppStorage(TypingSettings.initialDelayKey) private var initialDelay: Double = 0.35
    @AppStorage(TypingSettings.perCharacterDelayKey) private var perCharacterDelay: Double = 0.04
    @AppStorage(TypingSettings.recordingModeKey) private var recordingModeEnabled: Bool = false
    @AppStorage(HotKeySettings.keyCodeKey) private var hotKeyCode: Int = Int(kVK_ANSI_1)
    @AppStorage(HotKeySettings.modifiersKey) private var hotKeyModifiers: Int = Int(cmdKey)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TypePaste")
                .font(.title2)
            Text("Press Command + 1 to type the current clipboard text into the active app.")
                .fixedSize(horizontal: false, vertical: true)
            Text("If typing does not work, grant Accessibility permissions in System Settings > Privacy & Security > Accessibility.")
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text("Typing Delay")
                    .font(.headline)
                Toggle("Recording mode", isOn: $recordingModeEnabled)
                Text("When enabled, delays are bumped to avoid dropped characters during screen recording.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("Initial delay")
                    Spacer()
                    Text("\(initialDelay, specifier: "%.2f")s")
                        .foregroundStyle(.secondary)
                }
                Slider(value: $initialDelay, in: 0.05...1.5, step: 0.01)

                HStack {
                    Text("Per character")
                    Spacer()
                    Text("\(perCharacterDelay, specifier: "%.2f")s")
                        .foregroundStyle(.secondary)
                }
                Slider(value: $perCharacterDelay, in: 0.01...0.2, step: 0.005)
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text("Hotkey")
                    .font(.headline)

                Picker("Key", selection: $hotKeyCode) {
                    ForEach(HotKeySettings.availableKeys) { key in
                        Text(key.name).tag(key.keyCode)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Command (required)", isOn: Binding(
                        get: { true },
                        set: { _ in hotKeyModifiers = Int(HotKeySettings.sanitizeModifiers(UInt32(hotKeyModifiers))) }
                    ))
                    .disabled(true)

                    Toggle("Option", isOn: modifierBinding(for: UInt32(optionKey)))
                    Toggle("Control", isOn: modifierBinding(for: UInt32(controlKey)))
                    Toggle("Shift", isOn: modifierBinding(for: UInt32(shiftKey)))
                }

                Text("Current: \(HotKeySettings.displayString(keyCode: UInt32(hotKeyCode), modifiers: HotKeySettings.sanitizeModifiers(UInt32(hotKeyModifiers))))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .frame(width: 420)
    }

    private func modifierBinding(for flag: UInt32) -> Binding<Bool> {
        Binding(
            get: { (UInt32(hotKeyModifiers) & flag) != 0 },
            set: { isOn in
                var value = UInt32(hotKeyModifiers)
                if isOn {
                    value |= flag
                } else {
                    value &= ~flag
                }
                value = HotKeySettings.sanitizeModifiers(value)
                hotKeyModifiers = Int(value)
            }
        )
    }
}

#Preview {
    ContentView()
}
