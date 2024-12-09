//
//  ChatListManageableUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 12/6/24.
//

import Foundation
import SwiftData

class ChatListManageableUseCase: NSObject, ObservableObject, ChatBLMListManageableInterface {
    @Published var chatRoomList: [ChatRoom] = []
    enum Actions {
        case save(ChatRoom), delete(ChatRoom)
    }
    
    let context: ModelContext
    
    required init(context: ModelContext) {
        self.context = context
        super.init()
        getRooms()
    }
    
    func reduce(_ action: Actions) {
        switch action {
        case .save(let chatRoom):
            saveRoomData(chatRoom)
        case .delete(let chatRoom):
            deleteRoomData(chatRoom)
        }
    }
    
    private func getRooms() {
        do {
            let result = try context.fetch(FetchDescriptor(predicate: #Predicate<ChatRoom>{ _ in true }, sortBy: []))
            chatRoomList = result
        } catch {
            print("😡", error)
        }
    }
    
    private func saveRoomData(_ room: ChatRoom) {
        context.insert(room)
        getRooms()
    }
    
    private func deleteRoomData(_ room: ChatRoom) {
        context.delete(room)
        getRooms()
    }
}
