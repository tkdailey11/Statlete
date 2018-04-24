//
//  GameCell.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/7/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var liveTagView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var liveTagLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func commonInit(name: String, live: Bool){
        if(live == false){
          //  liveTagLabel.text = ""
            liveTagView.backgroundColor = UIColor.white
        }
            /*
        else{
            liveTagLabel.text = "LIVE"
            liveTagLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
         */ else{
            liveTagView.backgroundColor = Colors.orange
            liveTagLabel.text = "LIVE"
        }
          nameLabel.text = name
    }
    
}
