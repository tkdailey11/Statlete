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
    
    var statNames: [String] = ["Goals", "Assists", "Shots on Goal", "Shots", "Fouls", "Yellow Cards", "Red Cards", "Corners", "Saves", "Crosses", "Offsides"]
    
    init() {
    }
    
    init(id: String, name: String, halfLength: Int) {
        
        self.id = id
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
        DB.database.child("SoccerGames").child(self.id).child("InProgress").observe(.value, with: { (snapshot) in
            self.inProgress = snapshot.value as? Bool ?? false
        })
        for stat in statNames {
        }
    }
    
}
