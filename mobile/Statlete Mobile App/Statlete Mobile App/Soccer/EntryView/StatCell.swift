//
//  StatCell.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/4/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

protocol StatCellDelegate: class {
    func plusButtonPressed(index: Int)
    func minusButtonPressed(index: Int)
}

class StatCell: UITableViewCell {
    
    @IBOutlet var picture: UIImageView!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: StatCellDelegate? = nil
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    func commonInit(statName: String, index: Int){
        self.index = index
        label.text = statName
        label.textAlignment = .center
        label.center.x = self.center.x
        addSubview(label)
        self.autoresizingMask = [.flexibleWidth]
        
        minusButton.backgroundColor = Colors.color2
        plusButton.backgroundColor = Colors.color2
        
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        
        selectionStyle = .none
        picture.autoresizingMask = [.flexibleWidth]
    }
    
    @objc func plusButtonPressed() {
        delegate?.plusButtonPressed(index: index!)
    }
    
    @objc func minusButtonPressed() {
        delegate?.minusButtonPressed(index: index!)
    }
    
}
