//
//  Game.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerGame {
    
    var myTeamScore: Int
    var opposingTeamScore: Int
    var half: Int
    
    init() {
        myTeamScore = 0
        opposingTeamScore = 0
        half = 1
    }
    
    func setHalf(to half: Int) {
        self.half = half
    }
    
    func getHalf() -> Int {
        return half
    }
    
    func incrementMyTeamScore() {
        myTeamScore = myTeamScore + 1
    }
    
    func decrementMyTeamScore() {
        if myTeamScore > 0 {
            myTeamScore = myTeamScore - 1
        }
    }
    
    func incrementOpposingTeamScore() {
        opposingTeamScore = opposingTeamScore + 1
    }
    
    func decrementOpposingTeamScore() {
        if opposingTeamScore > 0 {
            opposingTeamScore = opposingTeamScore - 1
        }
    }
    
    
}
