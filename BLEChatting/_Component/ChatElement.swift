//
//  ChatElement.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/27/24.
//

import SwiftUI

struct ChatElement: View {
    @Environment(\.isDark) var isDark
    let isLeft: Bool
    
    var body: some View {
        HStack {
            if isLeft {
                _ContentsView
                Spacer()
            } else {
                Spacer()
                _ContentsView
            }
        }
        .background(isDark ? Color.black : Color.white)
    }
    
    private var _BlankView: some View {
        Rectangle()
            .fill(Color.clear)
    }
    
    private var _ContentsView: some View {
        HStack(alignment: .top, spacing: 4) {
            if isLeft {
                PersonThumbnail()
                    .frame(width: 40, height: 40)
                __TextArea
            } else {
                __TextArea
                PersonThumbnail()
                    .frame(width: 40, height: 40)
            }
        }
    }
    
    private var __TextArea: some View {
        Text(["안녕하세요! 어떻게 지내세요?",
              "좋아요, 감사합니다! 당신은요?",
              "저는 괜찮아요. 오늘 날씨가 참 좋네요.",
              "맞아요! 나중에 나가서 걸을까요?",
              "좋은 생각이에요. 몇 시에 만날까요?",
              "오후 3시가 어때요?",
              "완벽해요! 그때 봐요.",
              "기대하고 있을게요!",
              "안녕! 드디어 만났네요!",
              "안녕하세요! 음악 취향은 어떤가요?"].randomElement() ?? "")
        .foregroundStyle(isDark ? .white : .black)
        .frame(alignment: .leading)
        .lineLimit(nil)
        .padding(2)
    }
}

#Preview {
    ChatElement(isLeft: true)
}
