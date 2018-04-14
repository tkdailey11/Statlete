//
//  SoccerEntryModeController.swift
//  Soccer
//
//  Created by Nate Gygi on 3/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerEntryModeController: UIViewController, EntryViewDelegate, StatViewDelegate, SubstitutionBarDelegate, PossessionViewDelegate {
    
    
    var statNames: [String] = ["Goals", "Assists", "Shots on Goal", "Shots", "Fouls", "Yellow Cards", "Red Cards", "Corners", "Saves", "Crosses", "Offsides"]
    
    // For Scoreboard
    var timerStarted: Bool = false
    var timer = Timer()
    
    var oppTeamSelected: Bool = false
    
    var topBar: TopBar = TopBar()
    var bottomBar: BottomBar = BottomBar()
    var scoreboardView: ScoreboardView?
    var substitutionBar: SubstitutionBar = SubstitutionBar()
    var possessionBar: PossessionView = PossessionView()
    var entryView: SoccerTeamEntryView?
    var game: SoccerGame = SoccerGame()
    var shotChartEntryView: SoccerShotChartEntryView = SoccerShotChartEntryView()
    var statView: StatView = StatView()
    
    func addGameToDatabase() {
        let calendar = Calendar.current
        let dateString = "\(calendar.component(.month, from: game.date))-\(calendar.component(.day, from: game.date))-\(calendar.component(.year, from: game.date))"
        
        DB.database.child("SoccerGames").child(game.id).updateChildValues(["Date": dateString, "HalfLength": game.halfLength, "Name": game.name, "Period": game.half])
        DB.database.child("SoccerGames").child(game.id).updateChildValues(["MyTotals": " "])
        DB.database.child("SoccerGames").child(game.id).child("MyTotals").updateChildValues(["Period1": " ", "Period2": " "])
        DB.database.child("SoccerGames").child(game.id).updateChildValues(["OpponentsTotals": " "])
        DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").updateChildValues(["Period1": " ", "Period2": " "])
        for stat in statNames {
            DB.database.child("SoccerGames").child(game.id).child("MyTotals").child("Period1").updateChildValues([stat: ["Total": 0]])
            DB.database.child("SoccerGames").child(game.id).child("MyTotals").child("Period2").updateChildValues([stat: ["Total": 0]])
            DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").child("Period1").updateChildValues([stat: ["Total": 0]])
            DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").child("Period2").updateChildValues([stat: ["Total": 0]])
        }
        DB.database.child("SoccerGames").child(game.id).child("MyTotals").updateChildValues(["Possession": 0])
        DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").updateChildValues(["Possession": 0])
        DB.database.child("SoccerGames").child(game.id).updateChildValues(["InProgress": false])
        DB.database.child("SoccerGames").child(game.id).updateChildValues(["StartTime": 0])
        game.listenToDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = SoccerGame(id: "team2-1", name: "vs. Sparta 06", halfLength: 45)
        
        addGameToDatabase()
        
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
        substitutionBar.delegate = self
        view.addSubview(substitutionBar)
        
        // EntryView
        entryView = SoccerTeamEntryView(frame: entryViewFrame, statNames: statNames)
        view.addSubview(entryView!)
        entryView!.delegate = self
        
        // PossessionView
        possessionBar = PossessionView(frame: possessionBarFrame)
        possessionBar.delegate = self
        view.addSubview(possessionBar)
        
        // BottomBar
        bottomBar = BottomBar(frame: bottomBarFrame)
        view.addSubview(bottomBar)
        bottomBar.addTarget(self, action: #selector(tabChanged), for: .valueChanged)
        
        // ShotChartEntryView
        shotChartEntryView = SoccerShotChartEntryView(frame: shotChartFrame)
        view.addSubview(shotChartEntryView)
        
        view.sendSubview(toBack: shotChartEntryView)
        view.bringSubview(toFront: entryView!)
        
        // StatView
        statView = StatView(frame: statViewFrame)
        statView.delegate = self
        view.addSubview(statView)
        view.sendSubview(toBack: statView)
        
    }
    
    // Called when a tab is selected in the bottomBar
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
    
    // Called when the scoreboard timer is pressed
    @objc func scoreboardTimePressed() {
        if !game.inProgress {
            DB.database.child("SoccerGames").child(game.id).updateChildValues(["PeriodStartTime": Int(Date().timeIntervalSince1970)])
            DB.database.child("SoccerGames").child(game.id).updateChildValues(["InProgress": true])
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTime() {
        var minutes: Int = 0
        var seconds: Int = 0
        (minutes, seconds) = game.getTime()
        scoreboardView!.timeLabel.text = getTimeStringFrom(minutes: minutes, seconds: seconds)
        statView.teamStatView.tableView.reloadData()
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
    
    
    
    ////////////////////////////////////////
    /////// EntryView Callbacks  ///////////
    ////////////////////////////////////////
    func plusButtonPressed(index: Int) {
        if !game.inProgress {
            return
        }
        var minute = 0
        var second = 0
        (minute, second) = game.getTime()
        if (game.half == 1) {
            if (oppTeamSelected) {
                DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").child("Period1").child(game.statNames[index]).updateChildValues(["\(minute):\(second)":" "])
                DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").child("Period1").child(game.statNames[index]).updateChildValues(["Total": self.game.opp1stHalfTotals[statNames[index]]!+1])
                oppTeamSelected = false
                substitutionBar.setOpposingTeamButtonToNotSelected()
            }
            else {
                DB.database.child("SoccerGames").child(game.id).child("MyTotals").child("Period1").child(game.statNames[index]).updateChildValues(["\(minute):\(second)":" "])
                DB.database.child("SoccerGames").child(game.id).child("MyTotals").child("Period1").child(game.statNames[index]).updateChildValues(["Total": self.game.my1stHalfTotals[statNames[index]]!+1])
            }
        }
        else {
            if (oppTeamSelected) {
                DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").child("Period2").child(game.statNames[index]).updateChildValues(["\(minute):\(second)":" "])
                DB.database.child("SoccerGames").child(game.id).child("OpponentsTotals").child("Period2").child(game.statNames[index]).updateChildValues(["Total": self.game.opp2ndHalfTotals[statNames[index]]!+1])
                oppTeamSelected = false
                substitutionBar.setOpposingTeamButtonToNotSelected()
            }
            else {
                DB.database.child("SoccerGames").child(game.id).child("MyTotals").child("Period2").child(game.statNames[index]).updateChildValues(["\(minute):\(second)":" "])
                DB.database.child("SoccerGames").child(game.id).child("MyTotals").child("Period2").child(game.statNames[index]).updateChildValues(["Total": self.game.my2ndHalfTotals[statNames[index]]!+1])
            }
        }
        if index == 0 {
            scoreboardView?.myTeamScoreLabel.text = String(game.my1stHalfTotals[statNames[index]]! + game.my2ndHalfTotals[statNames[index]]!)
            scoreboardView?.opposingTeamScoreLabel.text = String(game.opp1stHalfTotals[statNames[index]]! + game.opp2ndHalfTotals[statNames[index]]!)
        }
        scoreboardView!.setNeedsDisplay()
        statView.teamStatView.tableView.reloadData()
    }
    
    func minusButtonPressed(index: Int) {
        if (game.half == 1) {
            if (oppTeamSelected) {
                if game.opp1stHalfTotals[statNames[index]]! > 0 {
                    game.opp1stHalfTotals[statNames[index]]! -= 1
                }
                oppTeamSelected = false
                substitutionBar.setOpposingTeamButtonToNotSelected()
            }
            else {
                if game.my1stHalfTotals[statNames[index]]! > 0 {
                    game.my1stHalfTotals[statNames[index]]! -= 1
                }
            }
        }
        else {
            if (oppTeamSelected) {
                if game.opp2ndHalfTotals[statNames[index]]! > 0 {
                    game.opp2ndHalfTotals[statNames[index]]! -= 1
                }
                oppTeamSelected = false
                substitutionBar.setOpposingTeamButtonToNotSelected()
            }
            else {
                if game.my2ndHalfTotals[statNames[index]]! > 0 {
                    game.my2ndHalfTotals[statNames[index]]! -= 1
                }
            }
        }
        if index == 0 {
            scoreboardView?.myTeamScoreLabel.text = String(game.my1stHalfTotals[statNames[index]]! + game.my2ndHalfTotals[statNames[index]]!)
            scoreboardView?.opposingTeamScoreLabel.text = String(game.opp1stHalfTotals[statNames[index]]! + game.opp2ndHalfTotals[statNames[index]]!)
        }
        scoreboardView!.setNeedsDisplay()
        statView.teamStatView.tableView.reloadData()
    }
    
    ////////////////////////////////////////
    /////// StatView Callbacks  ////////////
    ////////////////////////////////////////
    func getStatNameAndTeamValues(index: Int) -> (stat: String, myTeamVal: Int, oppTeamVal: Int) {
        let statName = statNames[index]
        return (statName, game.getMyTeamValueFor(stat: statName), game.getOppTeamValueFor(stat: statName))
    }
    
    
    func getNumberOfStats() -> Int {
        return statNames.count
    }
    
    
    func getPossessionValues() -> (myTeamPossession: TimeInterval, oppTeamPossession: TimeInterval) {
        return (game.myPossession, game.oppPossession)
    }
    
    ////////////////////////////////////////
    ///// SubstitutionBar Callbacks  ///////
    ////////////////////////////////////////
    func oppTeamButtonPressed() {
        oppTeamSelected = true
    }
    
    ////////////////////////////////////////
    ///// PossessionView Callbacks  ////////
    ////////////////////////////////////////
    
    var timePossessionSwitched: Date = Date()
    var currentlySelectedPossession: PossessionView.Selected = .out
    
    func myTeamPossessionSelected() {
        if currentlySelectedPossession == .oppTeam {
            let timeToAdd = timePossessionSwitched.timeIntervalSinceNow * -1
            game.oppPossession += timeToAdd
        }
        timePossessionSwitched = Date()
        currentlySelectedPossession = .myTeam
        statView.teamStatView.updateLabels()
    }
    
    func oppTeamPossessionSelected() {
        if currentlySelectedPossession == .myTeam {
            let timeToAdd = timePossessionSwitched.timeIntervalSinceNow * -1
            game.myPossession += timeToAdd
        }
        timePossessionSwitched = Date()
        currentlySelectedPossession = .oppTeam
        statView.teamStatView.updateLabels()
    }
    
    func outOfPlaySelected() {
        if currentlySelectedPossession == .oppTeam {
            let timeToAdd = timePossessionSwitched.timeIntervalSinceNow * -1
            game.oppPossession += timeToAdd
        }
        else if currentlySelectedPossession == .myTeam {
            let timeToAdd = timePossessionSwitched.timeIntervalSinceNow * -1
            game.myPossession += timeToAdd
        }
        currentlySelectedPossession = .out
        timePossessionSwitched = Date()
        statView.teamStatView.updateLabels()
    }
    
    // Required initializer
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
