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
            var players = value["Players"] as? [String: String] ?? [:]
            var games = value["Games"] as? [String: String] ?? [:]
            var sport = value["Sport"] as? String ?? ""
            var creator = value["Creator"] as? String ?? ""
            var admins = value["Admins"] as? [String: String] ?? [:]
            var teamName = value["TeamName"] as? String ?? ""
            var token = value["Token"] as? String ?? ""
            let teamSportfolio = Sportfolio(sportfolioId: sid, name: teamName, games: games, players: players, sport: sport, creator: creator, admins: Array(admins.keys), token: token)
            self.currentSportfolio = teamSportfolio
            completion(true)
        }) { (error) in
            completion(false)
            print("EEEEERRRROOOORRRR")
        }
    }
    
    
}
