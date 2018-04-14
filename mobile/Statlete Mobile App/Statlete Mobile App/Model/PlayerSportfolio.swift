//
//  PlayerSportfolio.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/13/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation

class PlayerSportfolio {
    
    // Initialized upon creation
    var id: String = String()
    var sport: String = String()
    var teamId: String = " "  // Linked team
    var name: String = String()
    var user: String = String()

    // Not initialized upon creation
    var games: [String: String] = [:]
    var totalStats : [String : Int] = [:]
    var teamName: String = String()
    
    var number: Int = Int()
    
    init(id: String, sport: String, teamId: String, name: String, user: String) {
        self.id = id
        self.sport = sport
        self.teamId = teamId
        self.name = name
        self.user = user
    }
}
