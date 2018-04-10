//
//  TeamStatView.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/6/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

protocol TeamStatViewDelegate: class {
    func getStatNameAndTeamValues(index: Int) -> (stat: String, myTeamVal: Int, oppTeamVal: Int)
    func getNumberOfStats() -> Int
}

class TeamStatView: UIControl, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView()
    
    weak var delegate: TeamStatViewDelegate?
    
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
        let nib = UINib.init(nibName: "TeamStatCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TeamStatCell")
        
        tableView.frame = CGRect(x: bounds.minX, y: bounds.minY + 140, width: bounds.width, height: bounds.height - 140)
        addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.getNumberOfStats() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatCell", for: indexPath) as? TeamStatCell {
                cell.headerInit()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatCell", for: indexPath) as? TeamStatCell {
            var statName: String = ""
            var myTeamVal: Int = 0
            var oppTeamVal: Int = 0
            (statName, myTeamVal, oppTeamVal) = delegate!.getStatNameAndTeamValues(index: indexPath.row-1)
            cell.commonInit(stat: statName, myTeamVal: myTeamVal, opposingTeamVal: oppTeamVal)
            return cell
        }
        return UITableViewCell()
    }
}
