//
//  SportfolioCell.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/2/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class SportfolioCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sportImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func commonInit(imageName: String, name: String){
        sportImage.image = UIImage(named: imageName)
        nameLabel.text = name
    }
    
}
