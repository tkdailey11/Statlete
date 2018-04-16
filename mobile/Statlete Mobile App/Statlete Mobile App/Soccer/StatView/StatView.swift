//
//  StatView.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/5/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

protocol StatViewDelegate: class {
    func getStatNameAndTeamValues(index: Int) -> (stat: String, myTeamVal: Int, oppTeamVal: Int)
    func getNumberOfStats() -> Int
    func getPossessionValues() -> (myTeamPossession: TimeInterval, oppTeamPossession: TimeInterval)
    func getNumberOfPlayers() -> Int
    func getPlayerInfo(index: Int) -> (number: String, name: String, goals: Int, assists: Int, shots: Int, shotsOnGoal: Int)
}

class StatView: UIControl, UITableViewDelegate, UITableViewDataSource, TeamStatViewDelegate {
    
    func getStatNameAndTeamValues(index: Int) -> (stat: String, myTeamVal: Int, oppTeamVal: Int) {
        return delegate!.getStatNameAndTeamValues(index: index)
    }
    
    
    func getNumberOfStats() -> Int {
        return delegate!.getNumberOfStats()
    }
    
    
    func getPossessionValues() -> (myTeamPossession: TimeInterval, oppTeamPossession: TimeInterval) {
        return delegate!.getPossessionValues()
    }
    
    
    let playerTableView = UITableView()
    var teamStatView: TeamStatView = TeamStatView()
    
    weak var delegate: StatViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.black
        playerTableView.delegate = self
        playerTableView.dataSource = self
        
        let nib = UINib.init(nibName: "PlayerStatCell", bundle: nil)
        playerTableView.register(nib, forCellReuseIdentifier: "PlayerStatCell")
        
        addSubview(playerTableView)
        playerTableView.frame = CGRect(x: bounds.minX, y: bounds.minY + 60, width: bounds.width, height: bounds.height - 60)
        
        teamStatView = TeamStatView(frame: CGRect(x: bounds.minX, y: bounds.minY + 60, width: bounds.width, height: bounds.height - 60))
        teamStatView.delegate = self
        addSubview(teamStatView)
        sendSubview(toBack: playerTableView)
        
        
        let playerStatsButton = UIButton()
        let teamStatsButton = UIButton()
        
        teamStatsButton.backgroundColor = UIColor.clear
        teamStatsButton.setTitle("Team Stats", for: .normal)
        teamStatsButton.setTitleColor(UIColor.white, for: .normal)
        teamStatsButton.frame = CGRect(x: bounds.minX, y: bounds.minY + 10, width: bounds.width/2, height: 40)
        teamStatsButton.titleLabel?.textAlignment = .center
        teamStatsButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        teamStatsButton.addTarget(self, action: #selector(teamButtonPressed), for: .touchUpInside)
        addSubview(teamStatsButton)
        
        playerStatsButton.backgroundColor = UIColor.clear
        playerStatsButton.setTitle("Player Stats", for: .normal)
        playerStatsButton.setTitleColor(UIColor.white, for: .normal)
        playerStatsButton.frame = CGRect(x: bounds.midX, y: bounds.minY + 10, width: bounds.width/2, height: 40)
        playerStatsButton.titleLabel?.textAlignment = .center
        playerStatsButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        playerStatsButton.addTarget(self, action: #selector(playerButtonPressed), for: .touchUpInside)
        addSubview(playerStatsButton)
    }
    
    @objc func teamButtonPressed() {
        sendSubview(toBack: playerTableView)
        bringSubview(toFront: teamStatView)
    }
    
    @objc func playerButtonPressed() {
        sendSubview(toBack: teamStatView)
        bringSubview(toFront: playerTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.getNumberOfPlayers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = playerTableView.dequeueReusableCell(withIdentifier: "PlayerStatCell", for: indexPath) as? PlayerStatCell {
                cell.headerInit()
                return cell
            }
        }
        if let cell = playerTableView.dequeueReusableCell(withIdentifier: "PlayerStatCell", for: indexPath) as? PlayerStatCell {
            let info = delegate!.getPlayerInfo(index: indexPath.row - 1)
            cell.commonInit(number: info.number, name: info.name, goals: info.goals, assists: info.assists, shots: info.shots, shotsOnGoal: info.shotsOnGoal)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}
