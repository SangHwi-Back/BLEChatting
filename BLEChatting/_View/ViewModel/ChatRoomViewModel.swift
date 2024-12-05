//
//  ChatRoomViewModel.swift
//  BLEChatting
//
//  Created by 백상휘 on 12/5/24.
//

import Foundation
import CoreBluetooth
import Combine

class ChatRoomViewModel: NSObject, ObservableObject {
    typealias Provider = (any ChatBLMInterface<ChatProviderUseCase.Actions>)
    
    let useCaseFactory: UseCaseFactory
    
    private let provider: Provider?
    let subscriber = ChatRoomViewModelSubscriber()
    
    @Published var characteristics: [CBCharacteristic] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(useCaseFactory: UseCaseFactory) {
        self.useCaseFactory = useCaseFactory
        self.provider = useCaseFactory.getUseCase(.peripheral(.TEST))
        super.init()
        
        subscriber
            .$characteristics
            .sink { characteristics in
                print("🙆‍♂️ \(characteristics.count)")
                self.characteristics = characteristics
            }
            .store(in: &subscriptions)
        provider?.reduce(.subscribe(subscriber))
    }
}

class ChatRoomViewModelSubscriber: Subscriber, ObservableObject {
    typealias Input = CBCharacteristic
    typealias Failure = Never
    
    @Published var characteristics: [CBCharacteristic] = []
    
    func receive(_ input: CBCharacteristic) -> Subscribers.Demand {
        characteristics.append(input)
        return .unlimited
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) { }
}
