//
//  EventDetailsViewModel.swift
//  BrisbanePoker
//
//  Created by Lucas Cullen on 3/4/19.
//  Copyright © 2019 AI. All rights reserved.
//

import Foundation

class EventDetailsViewModel {
    let _name: String
    let _description: String
    let _start: Date
    let _buyIn: Double
    let _fee: Double
    
    init(name: String, description: String, start: Date, buyIn: Double, fee: Double) {
        _name = name;
        _description = description;
        _start = start
        _buyIn = buyIn
        _fee = fee
    }
}
