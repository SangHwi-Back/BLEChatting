//
//  ChatProviderUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

class ChatProviderUseCase: ChatBLMProviderInterface {
    let centralManager: CBPeripheralManager
    
    required init(_ centralManager: CBPeripheralManager) {
        self.centralManager = centralManager
    }
    
    func sendMessage(characteristicID: String, message: String, chatRoomID: String) {
        
    }
    
    func sendData(characteristicID: String, data: Data, chatRoomID: String) {
        
    }
}
