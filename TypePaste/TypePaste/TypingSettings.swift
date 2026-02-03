//
//  TypingSettings.swift
//  TypePaste
//
//  Created by Tim Haselaars on 03/02/2026.
//

import Foundation

enum TypingSettings {
    static let initialDelayKey = "typing.initialDelay"
    static let perCharacterDelayKey = "typing.perCharacterDelay"
    static let recordingModeKey = "typing.recordingMode"

    private static let recordingInitialDelay: TimeInterval = 0.7
    private static let recordingPerCharacterDelay: TimeInterval = 0.05

    static var initialDelay: TimeInterval {
        let value = UserDefaults.standard.double(forKey: initialDelayKey)
        let base = value > 0 ? value : 0.35
        if isRecordingModeEnabled {
            return max(base, recordingInitialDelay)
        }
        return base
    }

    static var delayPerCharacter: TimeInterval {
        let value = UserDefaults.standard.double(forKey: perCharacterDelayKey)
        let base = value > 0 ? value : 0.04
        if isRecordingModeEnabled {
            return max(base, recordingPerCharacterDelay)
        }
        return base
    }

    static var isRecordingModeEnabled: Bool {
        UserDefaults.standard.bool(forKey: recordingModeKey)
    }
}
