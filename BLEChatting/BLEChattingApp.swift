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
    private var modelContainer: ModelContainer = {
        let schema = Schema([BLEChattingSchema.self])
        let configuration = ModelConfiguration(schema: schema,
                                               isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, 
                                      configurations: [configuration])
        } catch {
            fatalError("😫")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UseCaseFactory(modelContext: modelContainer.mainContext))
                .environment(\.isDark, colorScheme == .dark)
        }
        .modelContainer(modelContainer)
    }
}
