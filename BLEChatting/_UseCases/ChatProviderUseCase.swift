//
//  ChatProviderUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth
import Combine

class ChatProviderUseCase: NSObject, ChatBLMProviderInterface, ChatBLMInterface {
    enum Actions { case subscribe((any Subscriber<CBCharacteristic, Never>)), send(String) }
    
    var peripheralManager: CBPeripheralManager!
    let serviceID: CBUUID
    var characteristicID: CBUUID?
    let characteristicSubjects = CurrentValueSubject<CBCharacteristic, Never>(CBMutableCharacteristic(
        type: .CHARTEST,
        properties: [.read],
        value: nil,
        permissions: .readable))
    var concrete: ChatProviderUseCase {
        self
    }
    
    required init(serviceID: CBUUID) {
        self.serviceID = serviceID
        super.init()
        
        self.peripheralManager = .init(delegate: self, queue: nil)
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
    }
    
    func reduce(_ action: Actions) {
        switch action {
        case .subscribe(let subscriber):
            characteristicSubjects.receive(subscriber: subscriber)
        case .send(let message):
            sendMessage(characteristicID: CBUUID.CHARTEST, message: message)
        }
    }
}

extension ChatProviderUseCase: CBPeripheralManagerDelegate {
    // Manager State 업데이트 됨
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print(#function)
        switch peripheral.state {
        case .poweredOn:
            let service = CBMutableService(type: CBUUID.TEST, primary: true)
            let characteristic = CBMutableCharacteristic(type: CBUUID.CHARTEST,
                                                         properties: [.read, .notify],
                                                         value: nil,
                                                         permissions: .readable)
            service.characteristics = [characteristic]
            peripheralManager.add(service)
            peripheralManager.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: [serviceID],
                CBAdvertisementDataLocalNameKey: "BLEChatting",
            ])
        default:
            return
        }
    }
    // Peripheral 이 ATT 프로토콜을 통해 읽기 요청을 받음.
    // 값을 수신했으며, 응답을 보낼 수 있음.
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print(#function)
        guard request.characteristic.uuid == CBUUID.CHARTEST else { return }
        
        request.value = "HELLO".data(using: .utf8)
        peripheralManager.respond(to: request, withResult: .success)
        characteristicSubjects.send(request.characteristic)
    }
    
    
}
