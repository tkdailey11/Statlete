//
//  Game.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerGame {
    
    var id: String = String()
    var date: Date = Date()
    var name: String = String()
    var myTeamScore: Int = 0
    var opposingTeamScore: Int = 0
    var half: Int = 0
    var halfLength: Int = 0
    var startTime: Date = Date()
    var my1stHalfTotals = [String: Int]()
    var my2ndHalfTotals = [String: Int]()
    var opp1stHalfTotals = [String: Int]()
    var opp2ndHalfTotals = [String: Int]()
    var my1stHalfStats: StatSet = StatSet()
    var my2ndHalfStats: StatSet = StatSet()
    var opp1stHalfStats: StatSet = StatSet()
    var opp2ndHalfStats: StatSet = StatSet()
    var myPossession: TimeInterval = 0
    var oppPossession: TimeInterval = 0
    var inProgress: Bool = false
    var team: String = String()
    
    var players: [String: [String: Int]] = [:]
    var playerIDs: [String: String] = [:]
    var playerNames: [String: String] = [:]
    
    var statNames: [String] = ["Goals", "Assists", "Shots on Goal", "Shots", "Fouls", "Yellow Cards", "Red Cards", "Corners", "Saves", "Crosses", "Offsides"]
    
    init() {
    }
    
    init(team: String, gameID: String, name: String, halfLength: Int) {
        self.team = team
        self.id = gameID
        self.halfLength = 45
        self.name = "vs. Sparta 06"
        date = Date()
        half = 1
        myTeamScore = 0
        opposingTeamScore = 0
        for stat in statNames {
            my1stHalfTotals[stat] = 0
            my2ndHalfTotals[stat] = 0
            opp1stHalfTotals[stat] = 0
            opp2ndHalfTotals[stat] = 0
        }
        myPossession = 0
        oppPossession = 0
        loadPlayers()
    }
    
    func loadPlayers() {
        
        DB.database.child("TeamSportfolios/\(self.team)/Players").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: String] ?? ["": ""]
            for key in value.keys {
                self.players[key] = [:]
                for stat in self.statNames {
                    self.players[key]![stat] = 0
                }
                let playerSportfolioID = value[key] ?? ""
                self.playerIDs[key] = playerSportfolioID
                DB.database.child("PlayerSportfolios/\(playerSportfolioID)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.playerNames[key] = snapshot.value as? String ?? ""
                })
            }
            DB.database.child("SoccerGames/\(self.id)").updateChildValues(["Players": " "])
            for player in self.players {
                let playerString = player.key
                DB.database.child("SoccerGames/\(self.id)/Players/").updateChildValues([playerString: " "])
                
                DB.database.child("SoccerGames/\(self.id)/Players/\(playerString)").updateChildValues([self.statNames[0]: self.players[playerString]![self.statNames[0]]!, self.statNames[1]: self.players[playerString]![self.statNames[1]]!, self.statNames[2]: self.players[playerString]![self.statNames[2]]!, self.statNames[3]: self.players[playerString]![self.statNames[3]]!, self.statNames[4]: self.players[playerString]![self.statNames[4]]!, self.statNames[5]: self.players[playerString]![self.statNames[5]]!, self.statNames[6]: self.players[playerString]![self.statNames[6]]!, self.statNames[7]: self.players[playerString]![self.statNames[7]]!, self.statNames[8]: self.players[playerString]![self.statNames[8]]!, self.statNames[9]: self.players[playerString]![self.statNames[9]]!, self.statNames[10]: self.players[playerString]![self.statNames[10]]!])
            }
        })
    }
    
    
    func getTime() -> (minute: Int, second: Int) {
        let timeElapsed = startTime.timeIntervalSinceNow * -1
        return timeIntervalToMinutesAndSeconds(interval: timeElapsed)
    }
    
    func timeIntervalToMinutesAndSeconds(interval: TimeInterval) -> (minute: Int, second: Int) {
        var minutes = 0
        var seconds = 0
        let time: Int = Int(interval)
        minutes = time / 60
        seconds = time - (60 * minutes)
        return(minutes, seconds)
    }
    
    func getMyTeamValueFor(stat: String) -> Int {
        return my1stHalfTotals[stat]! + my2ndHalfTotals[stat]!
    }
    
    func getOppTeamValueFor(stat: String) -> Int {
        return opp1stHalfTotals[stat]! + opp2ndHalfTotals[stat]!
    }
    
    func listenToDatabase() {
        DB.database.child("SoccerGames").child(self.id).child("PeriodStartTime").observe(.value, with: { (snapshot) in
            self.startTime = Date(timeIntervalSince1970: TimeInterval(snapshot.value as? Int ?? 0))
        })
        DB.database.child("SoccerGames").child(self.id).child("Period").observe(.value, with: { (snapshot) in
            self.half = snapshot.value as? Int ?? 1
        })
        DB.database.child("SoccerGames").child(self.id).child("InProgress").observe(.value, with: { (snapshot) in
            self.inProgress = snapshot.value as? Bool ?? false
        })
        DB.database.child("SoccerGames").child(self.id).child("Period").observe(.value, with: { (snapshot) in
            self.half = snapshot.value as? Int ?? 0
        })
        DB.database.child("SoccerGames").child(self.id).child("MyTotals").child("Possession").observe(.value, with: { (snapshot) in
            self.myPossession = snapshot.value as? TimeInterval ?? 0
        })
        DB.database.child("SoccerGames").child(self.id).child("OpponentsTotals").child("Possession").observe(.value, with: { (snapshot) in
            self.oppPossession = snapshot.value as? TimeInterval ?? 0
        })
        for stat in statNames {
            DB.database.child("SoccerGames").child(self.id).child("MyTotals").child("Period1").child(stat).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.my1stHalfTotals[stat] = value?["Total"] as? Int ?? 0
            })
            DB.database.child("SoccerGames").child(self.id).child("MyTotals").child("Period2").child(stat).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.my2ndHalfTotals[stat] = value?["Total"] as? Int ?? 0
            })
            DB.database.child("SoccerGames").child(self.id).child("OpponentsTotals").child("Period1").child(stat).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.opp1stHalfTotals[stat] = value?["Total"] as? Int ?? 0
            })
            DB.database.child("SoccerGames").child(self.id).child("OpponentsTotals").child("Period2").child(stat).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.opp2ndHalfTotals[stat] = value?["Total"] as? Int ?? 0
            })
        }
    }
    
    func listenForPlayers() {
        for player in Array(players.keys) {
            DB.database.child("SoccerGames/\(id)/Players/\(player)").observe(.value, with: { (snapshot) in
                let value = snapshot.value as? [String: Int]
                for stat in value! {
                    self.players[player]![stat.key] = stat.value
                }
            })
        }
    }
    
}
