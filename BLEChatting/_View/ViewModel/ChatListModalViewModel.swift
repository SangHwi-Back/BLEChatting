//
//  ChatListModalViewModel.swift
//  BLEChatting
//
//  Created by 백상휘 on 12/9/24.
//

import Foundation
import CoreBluetooth
import Combine

class ChatListModalViewModel: NSObject, ObservableObject {
    typealias Responder = (any ChatBLMInterface<ChatResponderUseCase.Actions>)
    let useCaseFactory: UseCaseFactory
    private var responder: Responder?
    
    let subscriber = ChatListModalViewModelSubscriber()
    
    @Published var peripherals = [CBPeripheral]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(useCaseFactory: UseCaseFactory) {
        self.useCaseFactory = useCaseFactory
        super.init()
        
        self.responder = useCaseFactory.getUseCase(.central)
        
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

class ChatListModalViewModelSubscriber: Subscriber, ObservableObject {
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
