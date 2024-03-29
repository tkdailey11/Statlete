//
//  SoccerEntryModeController.swift
//  Soccer
//
//  Created by Nate Gygi on 3/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerEntryModeController: UIViewController {
    
    var topBar: TopBar = TopBar()
    var bottomBar: BottomBar = BottomBar()
    var scoreboardView: ScoreboardView?
    var substitutionBar: SubstitutionBar = SubstitutionBar()
    var possessionBar: PossessionView = PossessionView()
    var entryView: SoccerTeamEntryView = SoccerTeamEntryView()
    var game: Game = Game()
    var shotChartEntryView: SoccerShotChartEntryView = SoccerShotChartEntryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let possessionBarFrame: CGRect = CGRect(x: view.bounds.minX, y: view.bounds.maxY - 120, width: view.bounds.width, height: 80)
        let bottomBarFrame: CGRect = CGRect(x: view.bounds.minX, y: view.bounds.maxY - 40, width: view.bounds.width, height: 40)
        var rect: CGRect = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height - 120)
        var topBarFrame: CGRect = CGRect()
        var scoreboardViewFrame: CGRect = CGRect()
        var substitutionBarFrame: CGRect = CGRect()
        var entryViewFrame: CGRect = CGRect()
        var shotChartFrame: CGRect = CGRect()
        (topBarFrame, rect) = rect.divided(atDistance: 50, from: CGRectEdge.minYEdge)
        (scoreboardViewFrame, rect) = rect.divided(atDistance: 80, from: CGRectEdge.minYEdge)
        (substitutionBarFrame, entryViewFrame) = rect.divided(atDistance: 50, from: CGRectEdge.minYEdge)
        shotChartFrame = entryViewFrame
        
        // TopBar
        topBar = TopBar(frame: topBarFrame)
        view.addSubview(topBar)
        topBar.setGameLabel(to: "vs. Sparta 06 DM")
        
        // ScoreboardView
        scoreboardView = ScoreboardView(frame: scoreboardViewFrame, game: game)
        view.addSubview(scoreboardView!)
        
        // SubstitutionBar
        substitutionBar = SubstitutionBar(frame: substitutionBarFrame)
        view.addSubview(substitutionBar)
        
        // EntryView
        entryView = SoccerTeamEntryView(frame: entryViewFrame)
        view.addSubview(entryView)
        
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
        view.bringSubview(toFront: entryView)
        
    }
    
    @objc func tabChanged() {
        switch bottomBar.tabSelected {
        case 1:
            view.bringSubview(toFront: entryView)
        case 2:
            view.bringSubview(toFront: shotChartEntryView)
        case 3:
            print("tab 3 selected")
        default:
            print("Nothing")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
