//
//  SoccerTeamEntryView.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerTeamEntryView: UIControl, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView()
    
    var statNames = ["Goal", "Assist", "Shot on Goal", "Shot", "Foul", "Yellow Card", "Red Card", "Corner", "Save", "Pass"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib.init(nibName: "StatCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StatCell")
        
        addSubview(tableView)
        tableView.frame = bounds
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatCell {
            cell.commonInit(statName: statNames[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
