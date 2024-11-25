//
//  RepositoryView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/25/24.
//

import SwiftUI

struct RepositoryView: View {
    @State var items: [TestData]
    var body: some View {
        List(items) { item in
            Text(item.text)
        }
    }
}

#Preview {
    RepositoryView(items: [
        TestData(text: "First"),
        TestData(text: "Second"),
        TestData(text: "Third"),
    ])
}
