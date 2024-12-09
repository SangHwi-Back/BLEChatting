//
//  ChatRoomSchema.swift
//  BLEChatting
//
//  Created by 백상휘 on 11/24/24.
//

import Foundation
import SwiftData

@Model
final class BLEChattingSchema {
    var name: String
    @Relationship(deleteRule: .cascade) var rooms: [ChatRoom]
    
    init(name: String, rooms: [ChatRoom]) {
        self.name = name
        self.rooms = rooms
    }
}

@Model
final class ChatRoom {
    @Attribute(.unique) var serviceID: UUID
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var participants: [ChatParticipant]
    @Relationship(deleteRule: .cascade) var messages: [ChatMessage]
    
    init(serviceID: UUID, name: String) {
        self.serviceID = serviceID
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
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

@Model
final class ChatMessage {
    @Attribute(.unique) var messageID: UUID
    var content: String
    var sentAt: Date
    
    @Relationship var sender: ChatParticipant
    @Relationship var chatRoom: ChatRoom
    
    init(messageID: UUID,
         content: String,
         sender: ChatParticipant,
         chatRoom: ChatRoom
    ) {
        self.messageID = messageID
        self.content = content
        self.sentAt = Date()
        self.sender = sender
        self.chatRoom = chatRoom
    }
}
