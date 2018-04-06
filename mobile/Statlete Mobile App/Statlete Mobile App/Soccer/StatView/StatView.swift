//
//  StatView.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/5/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class StatView: UIControl, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    
    
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
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib.init(nibName: "PlayerStatCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PlayerStatCell")
        
        addSubview(tableView)
        tableView.frame = CGRect(x: bounds.minX, y: bounds.minY + 60, width: bounds.width, height: bounds.height - 60)
        
        let playerStatsButton = UIButton()
        let teamStatsButton = UIButton()
        
        teamStatsButton.backgroundColor = UIColor.clear
        teamStatsButton.setTitle("Team Stats", for: .normal)
        teamStatsButton.setTitleColor(UIColor.white, for: .normal)
        teamStatsButton.frame = CGRect(x: bounds.minX, y: bounds.minY + 10, width: bounds.width/2, height: 40)
        teamStatsButton.titleLabel?.textAlignment = .center
        teamStatsButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        addSubview(teamStatsButton)
        
        playerStatsButton.backgroundColor = UIColor.clear
        playerStatsButton.setTitle("Player Stats", for: .normal)
        playerStatsButton.setTitleColor(UIColor.white, for: .normal)
        playerStatsButton.frame = CGRect(x: bounds.midX, y: bounds.minY + 10, width: bounds.width/2, height: 40)
        playerStatsButton.titleLabel?.textAlignment = .center
        playerStatsButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        addSubview(playerStatsButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatCell", for: indexPath) as? PlayerStatCell {
                cell.headerInit()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatCell", for: indexPath) as? PlayerStatCell {
            cell.commonInit(number: 15, name: "Sehestedt, B.", minutes: 55, goals: 0, assists: 1, shots: 2, shotsOnGoal: 1)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}
