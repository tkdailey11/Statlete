//
//  SoccerEntryModeController.swift
//  Soccer
//
//  Created by Nate Gygi on 3/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerEntryModeController: UIViewController, EntryViewDelegate {
    
    func plusButtonPressed(index: Int) {
        if (game.half == 1) {
            game.my1stHalfTotals[statNames[index]]! += 1
            scoreboardView!.setNeedsDisplay()
        }
        else {
            game.my2ndHalfTotals[statNames[index]]! += 1
        }
        if index == 0 {
            scoreboardView?.myTeamScoreLabel.text = String(game.my1stHalfTotals[statNames[index]]! + game.my2ndHalfTotals[statNames[index]]!)
            scoreboardView?.opposingTeamScoreLabel.text = String(game.opp1stHalfTotals[statNames[index]]! + game.opp2ndHalfTotals[statNames[index]]!)
            scoreboardView?.setNeedsDisplay()
        }
    }
    
    func minusButtonPressed(index: Int) {
        if (game.half == 1) {
            if game.my1stHalfTotals[statNames[index]]! > 0 {
                game.my1stHalfTotals[statNames[index]]! -= 1
            }
        }
        else {
            if game.my2ndHalfTotals[statNames[index]]! > 0 {
                game.my2ndHalfTotals[statNames[index]]! -= 1
            }
        }
        if index == 0 {
            scoreboardView?.myTeamScoreLabel.text = String(game.my1stHalfTotals[statNames[index]]! + game.my2ndHalfTotals[statNames[index]]!)
            scoreboardView?.opposingTeamScoreLabel.text = String(game.opp1stHalfTotals[statNames[index]]! + game.opp2ndHalfTotals[statNames[index]]!)
            scoreboardView?.setNeedsDisplay()
        }
    }
    
    var statNames = ["Goals", "Assists", "Shots on Goal", "Shots", "Fouls", "Yellow Cards", "Red Cards", "Corners", "Saves", "Crosses", "Offsides"]
    
    // For Scoreboard
    var timerStarted: Bool = false
    var timer = Timer()
    
    var topBar: TopBar = TopBar()
    var bottomBar: BottomBar = BottomBar()
    var scoreboardView: ScoreboardView?
    var substitutionBar: SubstitutionBar = SubstitutionBar()
    var possessionBar: PossessionView = PossessionView()
    var entryView: SoccerTeamEntryView?
    var game: SoccerGame = SoccerGame()
    var shotChartEntryView: SoccerShotChartEntryView = SoccerShotChartEntryView()
    var statView: StatView = StatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = SoccerGame(id: "1", name: "Game 1", halfLength: 45, stats: statNames)
        
        view.backgroundColor = UIColor.white
        
        let possessionBarFrame: CGRect = CGRect(x: view.bounds.minX, y: view.bounds.maxY - 160, width: view.bounds.width, height: 120)
        let bottomBarFrame: CGRect = CGRect(x: view.bounds.minX, y: view.bounds.maxY - 40, width: view.bounds.width, height: 40)
        var rect: CGRect = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height - 160)
        var topBarFrame: CGRect = CGRect()
        var scoreboardViewFrame: CGRect = CGRect()
        var substitutionBarFrame: CGRect = CGRect()
        var entryViewFrame: CGRect = CGRect()
        var shotChartFrame: CGRect = CGRect()
        (topBarFrame, rect) = rect.divided(atDistance: 50, from: CGRectEdge.minYEdge)
        (scoreboardViewFrame, rect) = rect.divided(atDistance: 80, from: CGRectEdge.minYEdge)
        (substitutionBarFrame, entryViewFrame) = rect.divided(atDistance: 50, from: CGRectEdge.minYEdge)
        shotChartFrame = entryViewFrame
        let statViewFrame = CGRect(x: view.bounds.minX, y: view.bounds.minY + topBarFrame.height + scoreboardViewFrame.height, width: view.bounds.width, height: view.bounds.height - (topBarFrame.height + scoreboardViewFrame.height + bottomBarFrame.height))
        
        // TopBar
        topBar = TopBar(frame: topBarFrame)
        view.addSubview(topBar)
        topBar.setGameLabel(to: "vs. Sparta 06 DM")
        
        // ScoreboardView
        scoreboardView = ScoreboardView(frame: scoreboardViewFrame)
        view.addSubview(scoreboardView!)
        scoreboardView!.addTarget(self, action: #selector(scoreboardTimePressed), for: .valueChanged)
        scoreboardView!.myTeamScoreLabel.text = String(game.myTeamScore)
        scoreboardView!.opposingTeamScoreLabel.text = String(game.opposingTeamScore)
        scoreboardView!.half = game.half
        
        // SubstitutionBar
        substitutionBar = SubstitutionBar(frame: substitutionBarFrame)
        view.addSubview(substitutionBar)
        
        // EntryView
        entryView = SoccerTeamEntryView(frame: entryViewFrame, statNames: statNames)
        view.addSubview(entryView!)
        entryView!.delegate = self
        
        // PossessionView
        possessionBar = PossessionView(frame: possessionBarFrame)
        view.addSubview(possessionBar)
        
        // BottomBar
        bottomBar = BottomBar(frame: bottomBarFrame)
        view.addSubview(bottomBar)
        bottomBar.addTarget(self, action: #selector(tabChanged), for: .valueChanged)
        
        shotChartEntryView = SoccerShotChartEntryView(frame: shotChartFrame)
        view.addSubview(shotChartEntryView)
        
        view.sendSubview(toBack: shotChartEntryView)
        view.bringSubview(toFront: entryView!)
        
        statView = StatView(frame: statViewFrame)
        view.addSubview(statView)
        view.sendSubview(toBack: statView)
        
    }
    
    @objc func tabChanged() {
        switch bottomBar.tabSelected {
        case 1:
            view.sendSubview(toBack: statView)
            view.bringSubview(toFront: entryView!)
        case 2:
            view.sendSubview(toBack: statView)
            view.bringSubview(toFront: shotChartEntryView)
        case 3:
            view.bringSubview(toFront: statView)
            statView.bringSubview(toFront: statView.teamStatView)
            statView.sendSubview(toBack: statView.playerTableView)
        default:
            print("Nothing")
        }
    }
    
    @objc func scoreboardTimePressed() {
        if !timerStarted {
            game.startTimer()
            timerStarted = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTime() {
        var minutes: Int = 0
        var seconds: Int = 0
        (minutes, seconds) = game.getTime()
        scoreboardView!.timeLabel.text = getTimeStringFrom(minutes: minutes, seconds: seconds)
    }
    
    func getTimeStringFrom(minutes: Int, seconds: Int) -> String {
        var returnString: String = ""
        if (minutes < 10) {
            returnString.append("0\(minutes)")
        }
        else {
            returnString.append(String(minutes))
        }
        returnString.append(":")
        if (seconds < 10) {
            returnString.append("0\(seconds)")
        }
        else {
            returnString.append(String(seconds))
        }
        return returnString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
