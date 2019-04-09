//
//  StoredEvents.swift
//  BrisbanePoker
//
//  Created by AI on 29/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

class StoredEvents {
    private init() { }
    static let sharedInstance = StoredEvents()
    var collection = [EventModel]()
}
