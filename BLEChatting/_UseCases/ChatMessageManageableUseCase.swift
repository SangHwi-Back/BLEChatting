//
//  ChatMessageManageableUseCase.swift
//  BLEChatting
//
//  Created by 백상휘 on 12/9/24.
//

import Foundation
import CoreBluetooth
import SwiftData

class ChatMessageManageableUseCase: NSObject, ObservableObject, ChatBLMMesssageManageableInterface {
    @Published var messages: [ChatMessage] = []
    enum Actions {
        case save(ChatMessage), delete(ChatMessage)
    }
    
    private let chatRoom: ChatRoom
    let context: ModelContext
    
    required init(context: ModelContext, chatRoom: ChatRoom) {
        self.context = context
        self.chatRoom = chatRoom
        super.init()
        getMessages()
    }
    
    func reduce(_ action: Actions) {
        switch action {
        case .save(let chatMessage):
            saveMessage(chatMessage)
        case .delete(let chatMessage):
            deleteMessage(chatMessage)
        }
    }
    
    private func getMessages() {
        do {
            let id = chatRoom.serviceID
            let predicate = #Predicate<ChatMessage> { message in message.chatRoom.serviceID == id }
            let discriptor = FetchDescriptor<ChatMessage>(predicate: predicate, sortBy: [SortDescriptor(\.sentAt, order: .forward)]
            )
            let result = try context.fetch(discriptor)
            messages = result
        } catch {
            print(error)
        }
    }
    
    private func saveMessage(_ message: ChatMessage) {
        context.insert(message)
        getMessages()
    }
    
    private func deleteMessage(_ message: ChatMessage) {
        context.delete(message)
        getMessages()
    }
}
