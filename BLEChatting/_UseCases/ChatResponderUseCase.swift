//
//  ChatResponderUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth
import CryptoKit

class ChatResponderUseCase: NSObject, ChatBLMResponderInterface, ChatBLMInterface {
    enum Actions { case scan, getMessage, getPeripherals((Set<CBPeripheral>) -> Void) }
    
    let centralManager: CBCentralManager
    var peripherals: Set<CBPeripheral> = []
    let serviceID: CBUUID
    var concrete: ChatResponderUseCase {
        self
    }
    
    required init(_ centralManager: CBCentralManager, serviceID: CBUUID? = nil) {
        self.centralManager = centralManager
        
        if let serviceID {
            self.serviceID = serviceID
        } else {
            // MARK: - GENERATE UUID START
            let inputData = Data(Date().description.utf8)
            
            let hashed = SHA256.hash(data: inputData)
            let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
            
            let uuidString = String(hashString.prefix(32))
            let uuid = UUID(uuidString: uuidString.insertingSeparators())!
            // MARK: - GENERATE UUID END
            self.serviceID = CBUUID(nsuuid: uuid)
        }
    }
    
    func getMessagFromPeripheral() {
        // Clean Architecture 에서 Coordinator 와 Interactor 의 역할을 각각 정리해줘
    }
    
    func getDataFromPeripheral() {
        
    }
    
    private func scan() {
        centralManager.scanForPeripherals(
            withServices: [serviceID],
            options: [
                CBCentralManagerScanOptionAllowDuplicatesKey: true,
                CBCentralManagerRestoredStateScanOptionsKey: true,
                CBCentralManagerOptionShowPowerAlertKey: true,
            ])
    }
    
    func reduce(_ action: Actions) {
        switch action {
        case .scan:
            scan()
        case .getMessage:
            getMessagFromPeripheral()
        case .getPeripherals(let handler):
            handler(peripherals)
        }
    }
}

extension ChatResponderUseCase: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            scan()
        default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didConnect peripheral: CBPeripheral) {
        
        peripheral.discoverServices([serviceID])
        peripherals.insert(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        if Int(truncating: RSSI) < 50 {
            scan()
        }
    }
}

private extension String {
    func insertingSeparators() -> String {
        var result = self
        result.insert("-", at: result.index(result.startIndex, offsetBy: 8))
        result.insert("-", at: result.index(result.startIndex, offsetBy: 13))
        result.insert("-", at: result.index(result.startIndex, offsetBy: 18))
        result.insert("-", at: result.index(result.startIndex, offsetBy: 23))
        return result
    }
}
