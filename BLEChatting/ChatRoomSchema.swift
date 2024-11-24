//
//  ChatRoomSchema.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import Foundation
import SwiftData

@Model
final class ChatRoom {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var participants: [ChatParticipant]
    @Relationship(deleteRule: .cascade) var messages: [ChatMessage]
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.participants = []
        self.messages = []
    }
}

@Model
final class ChatParticipant {
    @Attribute(.unique) var id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

@Model
final class ChatMessage {
    var id: UUID
    var content: String
    var sentAt: Date
    @Relationship(deleteRule: .cascade) var sender: ChatParticipant
    @Relationship(deleteRule: .cascade) var chatRoom: ChatRoom
    
    init(content: String, sender: ChatParticipant, chatRoom: ChatRoom) {
        self.id = UUID()
        self.content = content
        self.sentAt = Date()
        self.sender = sender
        self.chatRoom = chatRoom
    }
}

