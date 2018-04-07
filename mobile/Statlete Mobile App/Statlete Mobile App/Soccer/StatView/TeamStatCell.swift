//
//  TeamStatCell.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/6/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class TeamStatCell: UITableViewCell {

    @IBOutlet weak var statLabel: UILabel!
    
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var opposingTeamLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func commonInit(stat: String, myTeamVal: Int, opposingTeamVal: Int) {
        //statLabel.textAlignment = .center
        statLabel.text = stat
        
        myTeamLabel.text = String(myTeamVal)
        //myTeamLabel.textAlignment = .center
        
        opposingTeamLabel.text = String(opposingTeamVal)
        //opposingTeamLabel.textAlignment = .center
    }
    
    
    func headerInit() {
        statLabel.text = ""
        
        myTeamLabel.text = "My Team"
        
        opposingTeamLabel.text = "Opp. Team"
    }
    
}
