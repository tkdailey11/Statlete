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
    var periodStartTime: Date = Date()
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
    var inProgress: Bool = false //
    var team: String = String()
    
    var players: [String: [String: Int]] = [:]
    var playerIDs: [String: String] = [:]
    var playerNames: [String: String] = [:]
    
    var isLoaded: Bool = false
    
    var statNames: [String] = ["Goals", "Assists", "Shots on Goal", "Shots", "Fouls", "Yellow Cards", "Red Cards", "Corners", "Saves", "Crosses", "Offsides"]
    
    
    init() {
    }
    
    init(team: String, gameID: String, name: String, halfLength: Int) {
        self.team = team
        self.id = gameID
        self.halfLength = 45
        self.name = name
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
        addGameToDatabase()
        isLoaded = true
    }
    
    
    init(team: String, gameID: String) {
        self.id = gameID
        self.team = team
        listenForPlayers()
        listenToDatabase()
    }
    
    
    func loadGameFromDatabase(completion: @escaping (Bool) -> Void) {
        DB.database.child("SoccerGames/\(self.id)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.half = value["Period"] as? Int ?? 5
            self.halfLength = value["HalfLength"] as? Int ?? 5
            self.inProgress = value["InProgress"] as? Bool ?? false
            self.name = value["Name"] as? String ?? ""
            self.periodStartTime = Date(timeIntervalSince1970: TimeInterval(value["PeriodStartTime"] as? Int ?? 0))
            let myTotals = value["MyTotals"] as? NSDictionary
            let myPeriod1Totals = myTotals?["Period1"] as? NSDictionary
            let myPeriod2Totals = myTotals?["Period2"] as? NSDictionary
            let oppTotals = value["OpponentsTotals"] as? NSDictionary
            let oppPeriod1Totals = oppTotals?["Period1"] as? NSDictionary
            let oppPeriod2Totals = oppTotals?["Period2"] as? NSDictionary
            for stat in self.statNames {
                let my1stHalf = myPeriod1Totals?[stat] as? NSDictionary
                self.my1stHalfTotals[stat] = my1stHalf?["Total"] as? Int ?? 0
                let my2ndHalf = myPeriod2Totals?[stat] as? NSDictionary
                self.my2ndHalfTotals[stat] = my2ndHalf?["Total"] as? Int ?? 0
                let opp1stHalf = oppPeriod1Totals?[stat] as? NSDictionary
                self.opp1stHalfTotals[stat] = opp1stHalf?["Total"] as? Int ?? 0
                let opp2ndHalf = oppPeriod2Totals?[stat] as? NSDictionary
                self.opp2ndHalfTotals[stat] = opp2ndHalf?["Total"] as? Int ?? 0
            }
            self.myPossession = TimeInterval(myTotals?["Possession"] as? Int ?? 0)
            self.oppPossession = TimeInterval(oppTotals?["Possession"] as? Int ?? 0)
            if let playerData = value["Players"] as? NSDictionary {
                for player in playerData.allKeys {
                    let playerString = player as? String ?? ""
                    self.players[playerString] = [:]
                    if let playerArray = playerData[player] as? [String: Int] {
                        for stat in self.statNames {
                            self.players[playerString]![stat] = playerArray[stat]
                        }
                    }
                }
            }
            self.isLoaded = true
            completion(true)
        }) { (error) in
            completion(false)
            print("EEEEERRRROOOORRRR")
        }
    }
    
    /*
    init(gameID: String, completion: @escaping (Bool) -> Void) {
        self.id = gameID
        
        DB.database.child("SoccerGames/\(self.id)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary ?? [:]
            self.loadGameFromDatabase(with: value)
            self.isLoaded = true
            completion(true)
        }) { (error) in
            completion(false)
            print("EEEEERRRROOOORRRR")
        }
    }
 */
    
    /*
    func loadGameFromDatabase() {
        DB.database.child("SoccerGames").child(self.id).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print("Made It")
        })
    }
 */
    
    /*
    func loadGameFromDatabase() {
        print("Here")
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.main.async {
            DB.database.child("SoccerGames").child(self.id).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                print("Made It")
                semaphore.signal()
            })
        }
        semaphore.wait()
        print("There")
    }
    */
 
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
        let timeElapsed = periodStartTime.timeIntervalSinceNow * -1
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
        if my1stHalfTotals.count != 0 && my2ndHalfTotals.count != 0 {
            return my1stHalfTotals[stat]! + my2ndHalfTotals[stat]!
        }
        return 0
    }
    
    func getOppTeamValueFor(stat: String) -> Int {
        if opp1stHalfTotals.count != 0 && opp2ndHalfTotals.count != 0 {
            return opp1stHalfTotals[stat]! + opp2ndHalfTotals[stat]!
        }
        return 0
    }
    
    func listenToDatabase() {
        DB.database.child("SoccerGames").child(self.id).child("PeriodStartTime").observe(.value, with: { (snapshot) in
            self.periodStartTime = Date(timeIntervalSince1970: TimeInterval(snapshot.value as? Int ?? 0))
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
    
    func addGameToDatabase() {
        let calendar = Calendar.current
        let dateString = "\(calendar.component(.month, from: date))-\(calendar.component(.day, from: date))-\(calendar.component(.year, from: date))"
        
        DB.database.child("SoccerGames").child(id).updateChildValues(["Date": dateString, "HalfLength": halfLength, "Name": name, "Period": half])
        DB.database.child("SoccerGames").child(id).updateChildValues(["MyTotals": " "])
        DB.database.child("SoccerGames").child(id).child("MyTotals").updateChildValues(["Period1": " ", "Period2": " "])
        DB.database.child("SoccerGames").child(id).updateChildValues(["OpponentsTotals": " "])
        DB.database.child("SoccerGames").child(id).child("OpponentsTotals").updateChildValues(["Period1": " ", "Period2": " "])
        for stat in statNames {
            DB.database.child("SoccerGames").child(id).child("MyTotals").child("Period1").updateChildValues([stat: ["Total": 0]])
            DB.database.child("SoccerGames").child(id).child("MyTotals").child("Period2").updateChildValues([stat: ["Total": 0]])
            DB.database.child("SoccerGames").child(id).child("OpponentsTotals").child("Period1").updateChildValues([stat: ["Total": 0]])
            DB.database.child("SoccerGames").child(id).child("OpponentsTotals").child("Period2").updateChildValues([stat: ["Total": 0]])
        }
        DB.database.child("SoccerGames").child(id).child("MyTotals").updateChildValues(["Possession": 0])
        DB.database.child("SoccerGames").child(id).child("OpponentsTotals").updateChildValues(["Possession": 0])
        DB.database.child("SoccerGames").child(id).updateChildValues(["InProgress": false])
        DB.database.child("SoccerGames").child(id).updateChildValues(["PeriodStartTime": 0])
        listenToDatabase()
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
