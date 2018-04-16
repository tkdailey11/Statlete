//
//  PlayerStatCell.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/5/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerStatCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var shotsLabel: UILabel!
    @IBOutlet weak var shotsOnGoalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(number: String, name: String, goals: Int, assists: Int, shots: Int, shotsOnGoal: Int) {
        numberLabel.text = "#\(number)"
        nameLabel.text = name
        goalsLabel.text = String(goals)
        assistsLabel.text = String(assists)
        shotsLabel.text = String(shots)
        shotsOnGoalLabel.text = String(shotsOnGoal)
        selectionStyle = .none
        
    }
    
    
    func headerInit() {
        numberLabel.text = ""
        nameLabel.text = ""
        goalsLabel.text = "Goals"
        assistsLabel.text = "Assists"
        shotsLabel.text = "Shots"
        shotsOnGoalLabel.text = "SOG"
        selectionStyle = .none
    }
}
