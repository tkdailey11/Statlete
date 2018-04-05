//
//  SubCell.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/4/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class SubCell: UICollectionViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func commonInit(number: Int) {
        button.setTitle("#\(number)", for: .normal)
    }
}
