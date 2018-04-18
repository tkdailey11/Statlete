//
//  PlayerCell.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/18/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var playerNameTextField: UITextField!
    
    @IBOutlet weak var playerNumberTextField: UITextField!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
