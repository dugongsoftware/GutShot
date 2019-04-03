//
//  EventModel.swift
//  BrisbanePoker
//
//  Created by AI on 29/3/19.
//  Copyright © 2019 AI. All rights reserved.
//
import Foundation

class EventModel {
    
    let name: String?
    let start: String? //to be time
    //let eventDate: Date?
    let buyin: Double?
    let fee: Double?
    let location: String?
    let type: String?
    let stack: Double?
    let levels: Double?
    let rebuys: Bool?
    
    //let nextDate: Date?
    
    init?(json: [String: Any]) {
        // 1
        self.name = json["name"] as? String
        self.buyin = json["buyin"] as? Double
        self.fee = json["fee"] as? Double
        self.location = json["location"] as? String
        self.type = json["type"] as? String
        self.stack = json["stack"] as? Double
        self.levels = json["levels"] as? Double
        self.rebuys = json["rebuys"] as? Bool
        self.start = json["start"] as? String
    }
    
//    init?(_name: String,  _start: String, _buyin: Double, _fee: Double, _location: String, _type: String, _stack: Double, _levels: Double, _rebuys: Bool) {
//        
//        self.name = _name
//        self.start = _start
//        self.buyin = _buyin
//        self.fee = _fee
//        self.location = _location
//        self.type = _type
//        self.stack = _stack
//        self.levels = _levels
//        self.rebuys = _rebuys
//    }
//    
    func nextDate(key: String, value: String) -> Date {
        //key as "weekly"
        //value as 1
        //should return Monday
        
        let currentDate = Date()
        return currentDate
    }
}
