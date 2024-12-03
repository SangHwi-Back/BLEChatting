//
//  ChatRoomView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI

struct ChatRoomView: View {
    typealias A = ChatResponderUseCase.Actions
    
    @Environment(UseCaseFactory.self) private var factory: UseCaseFactory
    @Environment(\.isDark) var isDark
    
    @State var text: String
    @State var responder: (any ChatBLMInterface<A>)?
    
    var body: some View {
        VStack(spacing: 4) {
            ScrollView {
                ForEach(0..<20) {
                    ChatElement(isLeft: $0.isMultiple(of: 2))
                        .padding(5)
                }
            }
            ChatBottomActionBar(text: $text)
        }
        .navigationTitle(text)
        .background(isDark ? Color.black : Color.white)
        .onAppear(perform: {
            responder = factory.getUseCase(.central)
            responder?.reduce(.scan)
        })
    }
}

#Preview {
    ChatRoomView(text: "Testing~~")
        .environment(UseCaseFactory())
}
