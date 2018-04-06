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
    
    @IBOutlet weak var minutesLabel: UILabel!
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
    
    func commonInit(number: Int, name: String, minutes: Int, goals: Int, assists: Int, shots: Int, shotsOnGoal: Int) {
        numberLabel.text = String(number)
        nameLabel.text = name
        minutesLabel.text = String(minutes)
        goalsLabel.text = String(goals)
        assistsLabel.text = String(assists)
        shotsLabel.text = String(shots)
        shotsOnGoalLabel.text = String(shotsOnGoal)
        
    }
    
    
    func headerInit() {
        numberLabel.text = ""
        nameLabel.text = ""
        minutesLabel.text = "Min"
        goalsLabel.text = "Goals"
        assistsLabel.text = "A"
        shotsLabel.text = "Shots"
        shotsOnGoalLabel.text = "SOG"
        
    }
}
