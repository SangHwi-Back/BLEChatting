//
//  BLEChattingApp.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI
import SwiftData

@main
struct BLEChattingApp: App {
    @Environment(\.colorScheme) var colorScheme
    private let useCaseFactory = UseCaseFactory()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(useCaseFactory)
                .environment(\.isDark, colorScheme == .dark)
        }
    }
}
