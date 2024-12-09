//
//  ContentView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/25/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @Environment(UseCaseFactory.self) var useCaseFactory: UseCaseFactory
    
    @State var selection: MainTab = .list
    
    enum MainTab {
        case list, second
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ChatList(viewModel: ChatListViewModel(useCaseFactory))
                .environmentObject(useCaseFactory)
                .environment(\.isDark, colorScheme == .dark)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }
                .tag(MainTab.list)
            RepositoryView(items: [
                TestData(text: "First"),
                TestData(text: "Second"),
                TestData(text: "Third"),
            ])
                .tabItem {
                    VStack {
                        Image(systemName: "swiftdata")
                        Text("Repo")
                    }
                }
                .tag(MainTab.list)
        }
    }
}

//#Preview {
//    ContentView()
//        .environmentObject(UseCaseFactory())
//}
