//
//  UseCaseFactory.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import SwiftData
import CoreBluetooth
import Combine

@Observable class UseCaseFactory: NSObject, ObservableObject {
    enum BLEManager {
        case central, peripheral(CBUUID)
        case roomList
        case chatList(ChatRoom)
    }
    
    typealias ResultUseCase<Actions> = (any ChatBLMInterface<Actions>)
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getUseCase<A>(_ manager: BLEManager) -> ResultUseCase<A>? {
        var result: (any ChatBLMInterface)?
        switch manager {
        case .peripheral(let serviceID):
            result = ChatProviderUseCase(serviceID: serviceID)
        case .central:
            result = ChatResponderUseCase()
        case .roomList:
            result = ChatListManageableUseCase(context: modelContext)
        case .chatList(let chatRoom):
            result = ChatMessageManageableUseCase(context: modelContext, chatRoom: chatRoom)
        }
        
        return result as? (any ChatBLMInterface<A>)
    }
}
