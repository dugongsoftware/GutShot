//
//  EventModel.swift
//  BrisbanePoker
//
//  Created by AI on 29/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

class EventModel {
    
    let name: String?
    let date: String?
    let buyin: Double?
    let fee: Double?
    let location: String?
    let type: String?
    let stack: Double?
    let levels: Double?
    let rebuys: Bool?
    
    init?(json: [String: Any]) {
        // 1
        self.name = json["name"] as? String
        self.date = json["date"] as? String
        self.buyin = json["buyin"] as? Double
        self.fee = json["fee"] as? Double
        self.location = json["location"] as? String
        self.type = json["type"] as? String
        self.stack = json["stack"] as? Double
        self.levels = json["levels"] as? Double
        self.rebuys = json["rebuys"] as? Bool
    }
    
}
