//
//  ChatBottomActionBar.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/27/24.
//

import SwiftUI

struct ChatBottomActionBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var text: String
    
    var onPressSend: (() -> Void)?
    
    var body: some View {
        
        let isDark = colorScheme == .dark
        
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isDark ? Color.gray : Color.white)
                .shadow(color: .gray, radius: 3, x: 0.0, y: 0.0)
            HStack(spacing: 8) {
                TextField("", text: $text, prompt: Text("Leave the message"))
                    .onSubmit { onPressSend?() }
                ZStack(alignment: .center) {
                    Circle()
                        .fill(LinearGradient(
                            colors: text.isEmpty ? [.white] : [.yellow, .blue],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .strokeBorder(isDark ? Color.white : Color.black)
                    Button {
                        print("Pressed send button")
                    } label: {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 10, height: 20)
                            .padding(8)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
            }
            .padding()
        }
        .frame(height: 70)
        .padding()
    }
}

#Preview {
    ChatBottomActionBar(text: .constant(""))
}
