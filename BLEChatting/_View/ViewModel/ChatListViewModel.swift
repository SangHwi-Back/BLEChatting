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
    @Published var userName: String = ""
    @Published var showModal = false
    @Published var items: [ChatRoom] = []
    
    @Published var error: InputError?
    
    enum InputError {
    case excceded
    }
    
    typealias DB = ChatBLMInterface<ChatListManageableUseCase.Actions>
    
    private var subscriptions: Set<AnyCancellable> = .init()
    
    private let db: (any DB)?
    
    init(_ useCaseFactory: UseCaseFactory) {
        db = useCaseFactory.getUseCase(.roomList)
        super.init()
        
        $userName
            .removeDuplicates()
            .map { [weak self] name in
                self?.validateName(name)
            }
            .assign(to: \.error, on: self)
            .store(in: &subscriptions)
    }
    
    private func validateName(_ name: String) -> InputError? {
        if name.count > 10 {
            return .excceded
        }
        return nil
    }
}
