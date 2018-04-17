//
//  TeamSportfolio.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/12/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation

class TeamSportfolio {
    
    // Initialized upon creation
    var id: String = String()
    var creator: String = String()
    var players: [String: String] = [:]
    var sport: String = String()
    var teamName: String = String()
  
    
    // Not initialized upon creation
    var games: [String: String] = [:]
    var token: String = String()
    var admins: [String] = [] // dont want this to be created upon init
    
    init(id: String, creator: String, sport: String, players: [String: String], teamName: String) {
        self.id = id
        self.creator = creator
        self.sport = sport
        self.players = players
        self.teamName = teamName
        admins.append(creator)
    }
}
