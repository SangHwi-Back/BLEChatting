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
    
    typealias DB = ChatBLMInterface<ChatListManageableUseCase.Actions>
    
    private let db: (any DB)?
    
    init(_ useCaseFactory: UseCaseFactory) {
        db = useCaseFactory.getUseCase(.roomList)
    }
}
