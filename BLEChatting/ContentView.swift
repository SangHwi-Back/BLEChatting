//
//  ContentView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/25/24.
//

import SwiftUI

struct ContentView: View {
    @State var selection: MainTab = .list
    @State var items = [
        TestData(text: "First"),
        TestData(text: "Second"),
        TestData(text: "Third"),
    ]
    
    enum MainTab {
        case list, second
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ChatList(items: items)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }
                .tag(MainTab.list)
            RepositoryView(items: items)
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

#Preview {
    ContentView()
}
