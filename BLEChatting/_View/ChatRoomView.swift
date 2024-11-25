//
//  ChatRoomView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI

struct ChatRoomView: View {
    var text: String
    
    var body: some View {
        VStack {
            Text("ChatRoomView")
            Text(text)
        }
    }
}

#Preview {
    ChatRoomView(text: "Testing~~")
}
