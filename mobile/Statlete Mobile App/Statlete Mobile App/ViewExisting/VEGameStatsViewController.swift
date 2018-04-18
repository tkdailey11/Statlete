//
//  VEGameStatsViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/9/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class VEGameStatsViewController: UIViewController, StatViewDelegate, ScoreboardViewDelegate {
    
    func getHalf() -> Int {
        return game.half
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    var topBar: TopBar = TopBar()
    var scoreboardView: ScoreboardView = ScoreboardView()
    var statView: StatView = StatView()
    
    var game: SoccerGame = SoccerGame()
    
    var timer = Timer()
    
    var hasChangedHalf: Bool = false
    
    @IBAction func SwitchCustomTableView(_ sender: UISegmentedControl) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        sleep(1)
        
        
        
        topBar = TopBar(frame: CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: 50))
        view.addSubview(topBar)
        topBar.setGameLabel(to: game.name)
        
        scoreboardView = ScoreboardView(frame: CGRect(x: view.bounds.minX, y: view.bounds.minY + 50, width: view.bounds.width, height: 80))
        view.addSubview(scoreboardView)
        scoreboardView.myTeamScoreLabel.text = String(game.myTeamScore)
        scoreboardView.opposingTeamScoreLabel.text = String(game.opposingTeamScore)
        scoreboardView.half = game.half
        scoreboardView.delegate = self
        scoreboardView.setNeedsDisplay()
        
        statView = StatView(frame: CGRect(x: view.bounds.minX, y: view.bounds.minY + 130, width: view.bounds.width, height: view.bounds.height - 130))
        statView.delegate = self
        view.addSubview(statView)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if !game.inProgress {
            scoreboardView.timeLabel.text = getTimeStringFrom(minutes: 0, seconds: 0)
            return
        }
        if !hasChangedHalf && game.half == 2 {
            scoreboardView.half = 2
            hasChangedHalf = true
        }
        var minutes: Int = 0
        var seconds: Int = 0
        (minutes, seconds) = game.getTime()
        scoreboardView.timeLabel.text = getTimeStringFrom(minutes: minutes, seconds: seconds)
        scoreboardView.myTeamScoreLabel.text = String(game.my1stHalfTotals["Goals"]! + game.my2ndHalfTotals["Goals"]!)
        scoreboardView.opposingTeamScoreLabel.text = String(game.opp1stHalfTotals["Goals"]! + game.opp2ndHalfTotals["Goals"]!)
        scoreboardView.setNeedsDisplay()
        statView.teamStatView.updateLabels()
        statView.playerTableView.reloadData()
        statView.teamStatView.tableView.reloadData()
    }

    
    func getStatNameAndTeamValues(index: Int) -> (stat: String, myTeamVal: Int, oppTeamVal: Int) {
        let statName = game.statNames[index]
        return (statName, game.getMyTeamValueFor(stat: statName), game.getOppTeamValueFor(stat: statName))
    }
    
    
    func getNumberOfStats() -> Int {
        return game.statNames.count
    }
    
    
    func getPossessionValues() -> (myTeamPossession: TimeInterval, oppTeamPossession: TimeInterval) {
        return (game.myPossession, game.oppPossession)
    }
    
    func getPlayerInfo(index: Int) -> (number: String, name: String, goals: Int, assists: Int, shots: Int, shotsOnGoal: Int) {
        let number = Array(game.players.keys)[index]
        let playerSportfolioID = game.playerIDs[number]
        var name = game.playerNames[number] ?? ""
        return (number, name, (game.players[number]?["Goals"])!, (game.players[number]?["Assists"])!, (game.players[number]?["Shots"])!, (game.players[number]?["Shots on Goal"])!)
    }
    
    func getNumberOfPlayers() -> Int {
        return game.players.count
    }
    
    // Convert minutes and seconds into a string represenatation to be used for scoreboard view
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
