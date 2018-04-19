//
//  Sportfolio.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/7/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation

/*
class Sportfolio{
    
    public var sportfolioId : String = String()
    public var name: String = String()
    public var games: [String:[String:String]] = [String:[String:String]]()
    public var players: [String:[String:String]] = [String:[String:String]]()
    public var playerStats: [String: [String: Int]] = [String: [String: Int]]() // if team sportfolio 
    
    init(sportfolioId: String, name: String, games: [String: [String : String]], players: [String: [String : String]], playerStats: [String: [String: Int]]){
        self.sportfolioId = sportfolioId
        self.name = name
        self.games = games
        self.players = players
        self.playerStats = playerStats
    }
    init(){
        
    }
}
*/

class Sportfolio{
    
    public var sportfolioId : String = String()
    public var name: String = String()
    public var games: [String:String] = [String:String]()
    public var players: [String:String] = [String:String]()
    //public var playerStats: [String: [String: Int]] = [String: [String: Int]]() // if team sportfolio
    
    init(sportfolioId: String, name: String, games: [String:String], players: [String:String]) {
        self.sportfolioId = sportfolioId
        self.name = name
        self.games = games
        self.players = players
    }
    init(){
        
    }
}

