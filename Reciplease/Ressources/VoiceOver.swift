//
//  VoiceOver.swift
//  Reciplease
//
//  Created by Yves Charpentier on 31/07/2022.
//

import Foundation

class VoiceOver {
    
    static let shared = VoiceOver()
    private init() {}
    
    func voiceOver(object: NSObject, hint: String) {
        object.isAccessibilityElement = true
        object.accessibilityLabel = hint
    }
}
