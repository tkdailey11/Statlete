//
//  CustomTableViewCell.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/2/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
