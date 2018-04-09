//
//  SoccerTeamEntryView.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

protocol EntryViewDelegate: class {
    func plusButtonPressed(index: Int)
    func minusButtonPressed(index: Int)
}

class SoccerTeamEntryView: UIControl, UITableViewDelegate, UITableViewDataSource, StatCellDelegate {
    
    weak var delegate: EntryViewDelegate?
    
    let tableView: UITableView = UITableView()
    
    var game: SoccerGame?
    
    var statNames: [String]
    
    init(frame: CGRect, statNames: [String]) {
        self.statNames = statNames
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        self.statNames = [String]()
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
            cell.commonInit(statName: statNames[indexPath.row], index: indexPath.row)
            cell.delegate = self
            if indexPath.row % 2 == 0 {
                cell.picture.image = #imageLiteral(resourceName: "soccer")
            }
            else {
                cell.picture.frame = CGRect(x: cell.picture.frame.minX - cell.picture.frame.width/4, y: cell.picture.frame.minY, width: cell.picture.frame.width * 3 / 2, height: cell.picture.frame.height)
                cell.picture.image = #imageLiteral(resourceName: "goal")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func plusButtonPressed(index: Int) {
        delegate?.plusButtonPressed(index: index)
    }
    
    func minusButtonPressed(index: Int) {
        delegate?.minusButtonPressed(index: index)
    }
}
