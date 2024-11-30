//
//  PopOver.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/30/24.
//

import SwiftUI

struct PopoverModel: Identifiable {
    var id: String { message }
    let message: String
}

private struct BLEChattingPopOver: ViewModifier {
    @Binding var model: PopoverModel?
    func body(content: Content) -> some View {
        content
            .popover(item: $model) { model in
                Text(model.message)
                    .presentationCompactAdaptation(.popover)
                    .padding()
            }
    }
}

extension View {
    func showPopover(_ model: Binding<PopoverModel?>) -> some View {
        self.modifier(BLEChattingPopOver(model: model))
    }
}
