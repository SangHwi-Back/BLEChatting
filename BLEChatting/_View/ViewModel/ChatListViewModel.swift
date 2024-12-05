//
//  ChatListViewModel.swift
//  BLEChatting
//
//  Created by 백상휘 on 12/5/24.
//

import Foundation
import CoreBluetooth
import Combine

class ChatListViewModel: NSObject, ObservableObject {
    typealias Responder = (any ChatBLMInterface<ChatResponderUseCase.Actions>)
    
    let useCaseFactory: UseCaseFactory
    
    private let responder: Responder?
    let subscriber = ChatListViewModelSubscriber()
    
    @Published var userName: String = ""
    @Published var showModal = false
    @Published var peripherals = [CBPeripheral]()
    @Published var items: [TestData] = [
        TestData(text: "First"),
        TestData(text: "Second"),
        TestData(text: "Third"),
    ]
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(useCaseFactory: UseCaseFactory) {
        self.useCaseFactory = useCaseFactory
        self.responder = useCaseFactory.getUseCase(.central)
        
        super.init()
        
        subscriber
            .$peripherals
            .sink { peripherals in
                print("👍 \(peripherals.count)")
                self.peripherals = peripherals
            }
            .store(in: &subscriptions)
        responder?.reduce(.scan(subscriber))
    }
}


class ChatListViewModelSubscriber: Subscriber, ObservableObject {
    typealias Input = Set<CBPeripheral>
    typealias Failure = Never
    
    @Published var peripherals: [CBPeripheral] = []
    
    func receive(_ input: Set<CBPeripheral>) -> Subscribers.Demand {
        peripherals = Array(input)
        return .unlimited
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) { }
}
