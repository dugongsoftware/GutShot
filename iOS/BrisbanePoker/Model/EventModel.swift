//
//  EventModel.swift
//  BrisbanePoker
//
//  Created by AI on 29/3/19.
//  Copyright © 2019 AI. All rights reserved.
//
import Foundation

class EventModel {
    
    let name: String
    let description: String
    let buyIn: Double
    let fee: Double
    let location: String
    let start: Date
    let imageURL: String
 
    init?(json: [String: Any], startDate: Date) {
        // 1
        self.name = json["name"] as! String
        self.description = json["description"] as! String
        self.buyIn = json["buyin"] as! Double
        self.fee = json["fee"] as! Double
        self.location = json["location"] as! String
        self.imageURL = json["imageURL"] as! String

        self.start = startDate
    }

}
