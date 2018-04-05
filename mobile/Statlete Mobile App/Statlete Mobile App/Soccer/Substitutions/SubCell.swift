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
    
    var number: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func commonInit(number: Int) {
        self.number = number
        button.setTitle("#\(number)", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    func subButtonInit() {
        self.number = -1
        button.setTitle("Sub", for: .normal)
    }
    
    @objc func buttonPressed() {
        print("#\(number) Pressed")
    }
}
