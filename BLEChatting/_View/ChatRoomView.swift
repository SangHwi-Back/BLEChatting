//
//  ChatRoomView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI

struct ChatRoomView: View {
    @Environment(\.isDark) var isDark
    @State var text: String
    
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
    }
}

#Preview {
    ChatRoomView(text: "Testing~~")
}
