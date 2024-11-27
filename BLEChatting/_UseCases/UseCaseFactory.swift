//
//  UseCaseFactory.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import Combine

@Observable class UseCaseFactory: NSObject, ObservableObject {
    
    let blm = ChatBLM()
    
    enum BLEManager {
        case central, peripheral
    }
    
    private var chatProviderUseCase: ChatProviderUseCase!
    private var chatReponderUseCase: ChatResponderUseCase!
    
    func getUseCase(_ manager: BLEManager) -> any ChatBLMInterface2 {
        switch manager {
        case .peripheral:
            if let chatProviderUseCase {
                return chatProviderUseCase
            } else {
                chatProviderUseCase = ChatProviderUseCase(blm.peripheralManager)
                return chatProviderUseCase
            }
        case .central:
            if let chatReponderUseCase {
                return chatReponderUseCase
            } else {
                chatReponderUseCase = ChatResponderUseCase(blm.centralManager)
                return chatReponderUseCase
            }
        }
    }
}

class AnyChatBLMInterface: ChatBLMInterface2 {
    let shared: any ChatBLMInterface2

    init<T: ChatBLMInterface2>(_ value: T) {
        self.shared = value
    }
}
