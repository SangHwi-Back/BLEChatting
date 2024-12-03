//
//  PersonThumbnail.swift
//  BLEChatting
//
//  Created by 백상휘 on 12/3/24.
//

import SwiftUI

struct PersonThumbnail: View {
    var name: String? = nil
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.gray.opacity(0.3))
            GeometryReader { proxy in
                Group {
                    if let prefix = name?.first {
                        Text(String(prefix).uppercased())
                            .font(.system(size: proxy.size.width * 0.6))
                            .foregroundColor(.black)
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.5)
                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
            }
            .padding(5)
        }
    }
}

#Preview {
    PersonThumbnail(name: "Mark")
}
