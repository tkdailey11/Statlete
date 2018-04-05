//
//  StatCell.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/4/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class StatCell: UITableViewCell {
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    func commonInit(statName: String){
        label.text = statName
        label.textAlignment = .center
        label.center.x = self.center.x
        addSubview(label)
        self.autoresizingMask = [.flexibleWidth]
        
        
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
    }
    
    @objc func plusButtonPressed() {
        print("Plus Button Pressed in \(label.text!)")
    }
    
    @objc func minusButtonPressed() {
        print("Minus Button Pressed in \(label.text!)")
    }
    
}
