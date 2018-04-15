//
//  SubCell.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/4/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

protocol SubCellDelegate: class {
    func buttonPressed(number: Int)
}

class SubCell: UICollectionViewCell {

    @IBOutlet weak var button: UIButton!
    
    var number: Int = 0
    
    weak var delegate: SubCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func commonInit(number: Int) {
        self.backgroundColor = Colors.color2
        self.number = number
        button.setTitle("#\(number)", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    func subButtonInit() {
        self.backgroundColor = Colors.color2
        self.number = -1
        button.setTitle("Sub", for: .normal)
    }
    
    @objc func buttonPressed() {
        delegate?.buttonPressed(number: number)
    }
}
