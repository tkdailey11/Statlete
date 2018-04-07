//
//  TeamStatView.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/6/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class TeamStatView: UIControl, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView()
    
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatCell", for: indexPath) as? TeamStatCell {
                cell.headerInit()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatCell", for: indexPath) as? TeamStatCell {
            cell.commonInit(stat: "Shots on Goal", myTeamVal: 5, opposingTeamVal: 6)
            return cell
        }
        return UITableViewCell()
    }
}
