//
//  UseCaseFactory.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth
import Combine

@Observable class UseCaseFactory: NSObject, ObservableObject {
    
    let blm = ChatBLM()
    
    enum BLEManager {
        case central, peripheral(CBUUID)
    }
    
    private var chatProviderUseCase: ChatProviderUseCase!
    private var chatReponderUseCase: ChatResponderUseCase!
    
    typealias ResultUseCase<Actions> = (any ChatBLMInterface<Actions>)
    
    func getUseCase<A>(_ manager: BLEManager) -> ResultUseCase<A>? {
        var result: (any ChatBLMInterface)?
        switch manager {
        case .peripheral(let serviceID):
            result = ChatProviderUseCase(blm.peripheralManager, serviceID: serviceID)
        case .central:
            result = ChatResponderUseCase(blm.centralManager)
        }
        
        return result as? (any ChatBLMInterface<A>)
    }
}
