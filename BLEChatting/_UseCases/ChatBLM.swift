//
//  ChatBLM.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/26/24.
//

import Foundation
import CoreBluetooth

class ChatBLM: NSObject, ObservableObject {
    var centralManager: CBCentralManager!
    // Peripheral 이 소유한 객체. 고유의 Peripheral service 에 대한 값을 발송(advertise)한다.
    var peripheralManager: CBPeripheralManager!
    
    private(set) var discoveredPeripheral: CBPeripheral?
    
    /// com.sanghwiback.BLEChatting
    private var characteristicUUID = CBUUID(string: "84f9487f-7a44-5d47-a53c-4561dbc9a424")
    
    // TODO: 간단히 String. 하지만 다른 타입도 지원하기 위해 제네릭 사용할지 여부는 고민 중.
    @Published var messages: [String] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self,
                                          queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self,
                                                queue: nil)
    }
    
    // Peripheral 으로써 블루투스 통해 데이터 전달 시도
    private func startAdvertising() {
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey: [CBUUID.TEST]]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    // Central 으로써 블루투스 연결할 기기 스캔 시도
    private func startScanning() {
        centralManager.scanForPeripherals(withServices: [CBUUID.TEST],
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
}

// MARK: CENTRAL
extension ChatBLM: CBCentralManagerDelegate {
    // Manager state 가 업데이트 됨
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScanning()
        default:
            return
        }
    }
    // Manager 블루투스 검색 와중에 Peripheral 을 발견함
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        
        guard Int(truncating: RSSI) > 50 else {
            startScanning()
            return
        }
        
        discoveredPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    // Manager 가 Peripheral 을 연결함
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID.TEST])
    }
}

// MARK: CENTRAL
extension ChatBLM: CBPeripheralDelegate {
    // Peripheral 서비스를 찾음. 블루투스 연결할 매니저를 찾음.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first else { return }
        peripheral.discoverCharacteristics([characteristicUUID], for: service)
    }
    // Peripheral service 의 characteristics 를 찾음.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristic = service.characteristics?.first else { return }
        peripheral.setNotifyValue(true, for: characteristic)
    }
    // Peripheral service 의 characteristics 수신을 성공함.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, let message = String(data: data, encoding: .utf8) else {
            return
        }
        
        print("Received!!! \(message)")
        messages.append(message)
    }
}

// MARK: PERIPHERAL
extension ChatBLM: CBPeripheralManagerDelegate {
    // Manager State 업데이트 됨
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            let service = CBMutableService(type: CBUUID.TEST, primary: true)
            let characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                         properties: [.read, .notify],
                                                         value: nil,
                                                         permissions: .readable)
            service.characteristics = [characteristic]
            peripheralManager.add(service)
            startAdvertising()
        default:
            return
        }
    }
    // Peripheral 이 ATT 프로토콜을 통해 읽기 요청을 받음.
    // 값을 수신했으며, 응답을 보낼 수 있음.
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
        guard request.characteristic.uuid == characteristicUUID else { return }
        
        request.value = "HELLO".data(using: .utf8)
        peripheralManager.respond(to: request, withResult: .success)
    }
    
    // 값 전송
    func sendMessage(_ message: String) {
        
        guard let data = message.data(using: .utf8) else { return }
        
        let value = CBMutableCharacteristic(type: characteristicUUID,
                                            properties: [.read, .notify],
                                            value: nil,
                                            permissions: .readable)
        peripheralManager.updateValue(data,
                                      for: value,
                                      onSubscribedCentrals: nil)
    }
}
