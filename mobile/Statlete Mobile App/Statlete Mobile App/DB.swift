//
//  DB.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/12/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation
import Firebase

class DB {
    
    public static var currentUser: User = User(name: "", email: "")
    public static var database: DatabaseReference = DatabaseReference()
    public static var currentSportfolio = Sportfolio()
   
    
    public static func loadTeamSportfolio(with sid: String, completion: @escaping (Bool) -> Void) {
        DB.database.child("TeamSportfolios/\(sid)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            print("TS: \(value)")
            let players = value["Players"] as? [String: String] ?? [:]
            let games = value["Games"] as? [String: String] ?? [:]
            let sport = value["Sport"] as? Int ?? 1
            let creator = value["Creator"] as? String ?? ""
            let admins = value["Admins"] as? [String: String] ?? [:]
            let teamName = value["TeamName"] as? String ?? ""
            let token = value["Token"] as? String ?? ""
            let teamSportfolio = Sportfolio(sportfolioId: sid, name: teamName, games: games, players: players, sport: sport, creator: creator, admins: Array(admins.keys), token: token, type: 1)
            self.currentSportfolio = teamSportfolio
            completion(true)
        }) { (error) in
            completion(false)
            print("EEEEERRRROOOORRRR")
        }
    }
  
    public static func loadPlayerSportfolio(with sid: String, completion: @escaping (Bool) -> Void) {
        DB.database.child("PlayerSportfolios/\(sid)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
          //  var players = value["Players"] as? [String: String] ?? [:]
            let games = value["Games"] as? [String: String] ?? [:]
           // var sport = value["Sport"] as? String ?? ""
            let sport = value["Sport"] as? Int ?? 1
            let creator = value["User"] as? String ?? ""
            let num = value["Number"] as? Int ?? 0
            let admins = value["Admins"] as? [String: String] ?? [:]
            let name = value["Name"] as? String ?? ""
            let players:[String: String] = ["p\(num)" : "\(name)"]
            let totals = value["TotalStats"] as? [String: String] ?? [:]
            let token = ""
            let playerSportfolio = Sportfolio(sportfolioId: sid, name: name, games: games, players: players, sport: sport, creator: creator, admins: Array(admins.keys), token: token, type: 0)
            self.currentSportfolio = playerSportfolio
            self.currentSportfolio.psTotals = totals
            completion(true)
        }) { (error) in
            completion(false)
            print("EEEEERRRROOOORRRR")
        }
    }
    
    public static func loadPlayerStats(with gameid: String, completion: @escaping (Bool) -> Void) {
        DB.database.child("SoccerGames/\(gameid)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            print(value)
            let playersData = value["Players"] as? NSDictionary ?? [:]
            print(playersData)
            
            self.currentSportfolio.playerStats = playersData
            self.currentSportfolio.addToTotals(player: "", stats: playersData)
            completion(true)
            
        }) { (error) in
            completion(false)
            print("EEEEERRRROOOORRRR")
        }
    }
    
    
    
}
