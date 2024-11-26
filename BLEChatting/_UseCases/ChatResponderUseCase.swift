//
//  ChatResponderUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

class ChatResponderUseCase: ChatBLMResponderInterface {
    
    let centralManager: CBCentralManager
    
    required init(_ centralManager: CBCentralManager) {
        self.centralManager = centralManager
    }
    
    func getMessagFromPeripheral(peripheralID: String, message: String) {
        
    }
    
    func getDataFromPeripheral(peripheralID: String, data: Data) {
        
    }
    
    func getDictFromPeripheral(peripheralID: String, dict: Dictionary<String, Any>) {
        
    }
}
