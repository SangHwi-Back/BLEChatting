//
//  ChatRoomView.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import SwiftUI
import CoreBluetooth

struct ChatRoomView: View {
    typealias A = ChatProviderUseCase.Actions
    
    @Environment(UseCaseFactory.self) private var factory: UseCaseFactory
    @Environment(\.isDark) var isDark
    
    @State var text: String = ""
    @State var provider: (any ChatBLMInterface<A>)?
    
    private var serviceID: CBUUID
    
    @ObservedObject var viewModel: ChatRoomViewModel
    
    init(serviceID: CBUUID, viewModel: ChatRoomViewModel) {
        self.serviceID = serviceID
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ScrollView {
                ForEach(0..<20) {
                    ChatElement(isLeft: $0.isMultiple(of: 2))
                        .padding(5)
                }
            }
            ChatBottomActionBar(text: $text) {
                provider?.reduce(.send(text))
            }
        }
        .navigationTitle("채팅방 ㅎㅎ")
        .background(isDark ? Color.black : Color.white)
        .onAppear(perform: {
            provider = factory.getUseCase(.peripheral(serviceID))
        })
    }
}

#Preview {
    ChatRoomView(serviceID: .TEST, viewModel: ChatRoomViewModel(useCaseFactory: UseCaseFactory()))
        .environment(UseCaseFactory())
}
