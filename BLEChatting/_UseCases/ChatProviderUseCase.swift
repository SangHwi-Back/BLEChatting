//
//  ChatProviderUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

class ChatProviderUseCase: ChatBLMProviderInterface, ChatBLMInterface {
    enum Actions { case send(String) }
    
    let peripheralManager: CBPeripheralManager
    let serviceID: CBUUID
    var characteristicID: CBUUID?
    var concrete: ChatProviderUseCase {
        self
    }
    
    required init(_ peripheralManager: CBPeripheralManager, serviceID: CBUUID) {
        self.peripheralManager = peripheralManager
        self.serviceID = serviceID
    }
    
    func sendMessage(characteristicID: CBUUID, message: String) {
        let data = Data(message.utf8)
        
        peripheralManager.updateValue(
            data,
            for: CBMutableCharacteristic(
                type: characteristicID,
                properties: [.read],
                value: data,
                permissions: .readable),
            onSubscribedCentrals: nil
        )
        
        if peripheralManager.isAdvertising == false {
            peripheralManager.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: serviceID
            ])
        }
    }
    
    func reduce(_ action: Actions) {
        switch action {
        case .send(let message):
            guard let characteristicID else {
                return
            }
            sendMessage(characteristicID: characteristicID, message: message)
        }
    }
}
