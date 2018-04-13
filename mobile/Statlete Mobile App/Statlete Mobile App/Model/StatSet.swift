//
//  StatSet.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/13/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation

class StatSet {
    
    var stats: [(minute: Int, player: String)]
    
    init() {
        stats = []
    }
    
    func addStat(minute: Int, player: String) {
        stats.append((minute: minute, player: player))
    }
}
