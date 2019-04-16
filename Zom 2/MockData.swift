//
//  MockData.swift
//  Zom 2
//
//  Created by N-Pex on 15.04.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import MatrixKit

class MockData {
    class func setup() {
        let creds = MXCredentials(homeServer: "example.com", userId: "@user:example.com", accessToken: "12345678")
        
        let account = MXKAccount(credentials: creds)
        MXKAccountManager.shared()?.addAccount(account, andOpenSession: true)
        if let session = account?.mxSession {
            if let room = MockData.addRoom(session: session, id: "1", title: "Nikita Borisov") {
                addEvent(room: room, message: "Olá")
            }
            if let room = MockData.addRoom(session: session, id: "2", title: "Whitfield Diffie") {
                addEvent(room: room, message: "Hello")
            }
            if let room = MockData.addRoom(session: session, id: "3", title: "Martin Hellman") {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
                    addEvent(room: room, message: "Bonjour")
                    addEvent(room: room, message: "Hi!", sender: "@martin.hellman:example.com", updateSummary: false)
                    addEvent(room: room, message: "Good evening!", updateSummary: false)
                    addEvent(room: room, message: ":olo and shimi-11flowers:", updateSummary: false)
                }
            }
        }
    }
    
    private class func addRoom(session:MXSession, id:String, title:String) -> MXRoom? {
        if let room = session.perform(Selector("getOrCreateRoom:notify:"), with: id, with: true)?.takeUnretainedValue() as? MXRoom {
            room.summary.__membership = __MXMembershipJoin
            room.summary.displayname = title
            return room
        }
        return nil
    }
    
    private class func addDummyEvent(room:MXRoom) {
        guard let event = room.fakeEvent(withEventId: UUID().uuidString, eventType: "m.ignored", andContent: [:]) else {return}
        room.mxSession.store.storeEvent(forRoom: room.roomId, event: event, direction: __MXTimelineDirectionForwards)
    }
    
    private class func createMessageEvent(message:String, sender:String = "@user:example.com") -> MXEvent? {
        let event = MXEvent()
        event.eventId = UUID().uuidString
        event.wireType = kMXEventTypeStringRoomMessage
        event.originServerTs = UInt64(Date().timeIntervalSince1970 * 1000)
        event.sender = sender
        event.wireContent = [
            "body":message,
            "type":"m.room.message",
            "msgtype":"m.text"
            ]
        if sender == "@user:example.com" {
            event.sentState = MXEventSentStateSent
        }
        return event
    }
    
    private class func addEvent(room:MXRoom, message:String, sender:String = "@user:example.com", updateSummary:Bool = true) {
        guard let event = room.fakeEvent(withEventId: UUID().uuidString, eventType: kMXEventTypeStringRoomMessage, andContent: [
            "body":message,
            "type":"m.room.message",
            "msgtype":"m.text"
            ]) else {return}
        event.sender = sender
        if sender == "@user:example.com" {
            event.sentState = MXEventSentStateSent
        }
        room.mxSession.store.storeEvent(forRoom: room.roomId, event: event, direction: __MXTimelineDirectionForwards)
        if updateSummary {
            room.summary.handle(event)
        }
    }
}
