//
//  IssueListComponent.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/25/24.
//

import SwiftUI

struct IssueListComponent: View {
    @State var text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue)
                .opacity(0.7)
            VStack(alignment: .leading) {
                Text("IssueListComponent")
                Text(text)
            }
        }
        .frame(height: 120)
        .padding(.horizontal)
    }
}

#Preview {
    IssueListComponent(text: "")
}
