//
//  Game.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerGame {
    
    var id: String
    var date: Date
    var name: String
    var myTeamScore: Int
    var opposingTeamScore: Int
    var half: Int
    var halfLength: Int
    var time: TimeInterval
    var startTime: Date?
    var my1stHalfTotals = [String: Int]()
    var my2ndHalfTotals = [String: Int]()
    var opp1stHalfTotals = [String: Int]()
    var opp2ndHalfTotals = [String: Int]()
    var my1stHalfPossession: TimeInterval
    var my2ndHalfPossession: TimeInterval
    var opp1stHalfPossession: TimeInterval
    var opp2ndHalfPossession: TimeInterval
    
    init(id: String, name: String, halfLength: Int, stats: [String]) {
        self.id = id
        self.name = name
        date = Date()
        self.halfLength = halfLength
        myTeamScore = 0
        opposingTeamScore = 0
        half = 1
        time = 0
        for stat in stats {
            my1stHalfTotals[stat] = 0
            my2ndHalfTotals[stat] = 0
            opp1stHalfTotals[stat] = 0
            opp2ndHalfTotals[stat] = 0
        }
        my1stHalfPossession = 0
        my2ndHalfPossession = 0
        opp1stHalfPossession = 0
        opp2ndHalfPossession = 0
    }
    
    init() {
        self.id = ""
        self.name = ""
        date = Date()
        self.halfLength = 0
        myTeamScore = 0
        opposingTeamScore = 0
        half = 1
        time = 0
        my1stHalfPossession = 0
        my2ndHalfPossession = 0
        opp1stHalfPossession = 0
        opp2ndHalfPossession = 0
    }
    
    func getTime() -> (minute: Int, second: Int) {
        let timeElapsed = startTime!.timeIntervalSinceNow * -1
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
    
}
