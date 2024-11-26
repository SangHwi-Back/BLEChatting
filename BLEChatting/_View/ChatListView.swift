//
//  ContentView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI
import SwiftData

struct TestData: Identifiable, Hashable {
    let text: String
    let id: UUID = UUID()
}

struct ChatList: View {
    @Environment(UseCaseFactory.self) private var factory: UseCaseFactory
    @State var items: [TestData]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            IssueListComponent(testData: item)
                                .foregroundColor(Color.black)
                        }
                        Button {
                            print((factory.getUseCase(.central) as? ChatResponderUseCase) == nil ? "It's Nil" : "It's not nil")
                        } label: {
                            Text(item.text)
                        }
                    }
                }
            }
            .navigationDestination(for: TestData.self) { item in
                ChatRoomView(text: item.text)
            }
        }
    }
}

#Preview {
    ContentView()
}
