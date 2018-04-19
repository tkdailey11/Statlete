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
    public var sportfolioId : String = String()
    public var teamName: String = String()
    var sport: String = String()
    var creator: String = String()

    public var games: [String:[String:String]] = [String:[String:String]]()
    public var players: [String:[String:String]] = [String:[String:String]]()
    public var playerStats: [String: [String: Int]] = [String: [String: Int]]()
    
      // Not initialized upon creation
    var token: String = String()
    var admins: [String] = []
    
    init(sportfolioId: String, teamName: String, creator: String, sport: String, games: [String: [String : String]], players: [String: [String : String]], playerStats: [String: [String: Int]]){
        
        self.sportfolioId = sportfolioId
        self.teamName = teamName
        self.creator = creator
        self.sport = sport
        self.games = games
        self.players = players
        self.playerStats = playerStats
    }
    init(){
        
    }
    
}
