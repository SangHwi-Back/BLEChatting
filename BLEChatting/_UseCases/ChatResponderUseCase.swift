//
//  ChatResponderUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth
import CryptoKit
import Combine

class ChatResponderUseCase: NSObject, ChatBLMResponderInterface, ChatBLMInterface {
    enum Actions {
        case scan((any Subscriber<Set<CBPeripheral>, Never>)),
             getPeripherals((Set<CBPeripheral>) -> Void)
    }
    
    var centralManager: CBCentralManager!
    var concrete: ChatResponderUseCase {
        self
    }
    private var bluetoothOn = false
    let peripheralSubjects = CurrentValueSubject<Set<CBPeripheral>, Never>([])
    
    required init(serviceID: CBUUID? = nil) {
        super.init()
        self.centralManager = .init(delegate: self, queue: nil)
    }
    
    private func scan() {
        guard bluetoothOn else {
            return
        }
        
        centralManager.scanForPeripherals(
            withServices: [CBUUID.TEST],
            options: [
                CBCentralManagerScanOptionAllowDuplicatesKey: true,
                CBCentralManagerRestoredStateScanOptionsKey: true,
                CBCentralManagerOptionShowPowerAlertKey: true,
            ])
    }
    
    func reduce(_ action: Actions) {
        switch action {
        case .scan(let subscriber):
            peripheralSubjects.receive(subscriber: subscriber)
        case .getPeripherals(let handler):
            handler(peripheralSubjects.value)
        }
    }
}

extension ChatResponderUseCase: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(#function)
        switch central.state {
        case .poweredOn:
            bluetoothOn = true
            scan()
        default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didConnect peripheral: CBPeripheral) {
        print(#function)
        peripheral.discoverServices([CBUUID.TEST])
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print(#function)
        guard Int(truncating: RSSI) >= 50 else {
            scan()
            return
        }
        
        peripheral.delegate = self
        var peripherals = peripheralSubjects.value
        peripherals.insert(peripheral)
        peripheralSubjects.send(peripherals)
    }
}

extension ChatResponderUseCase: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: (any Error)?) {
        if let error {
            print(error)
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
