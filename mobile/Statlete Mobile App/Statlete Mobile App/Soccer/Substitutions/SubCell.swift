//
//  SubCell.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/4/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

protocol SubCellDelegate: class {
    func buttonPressed(button: UIButton, number: Int)
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
        self.backgroundColor = Colors.red
        self.number = number
        button.setTitle("#\(number)", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setTitleColor(Colors.red, for: .normal)
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(UIColor.darkGray.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        var colorImage = UIGraphicsGetImageFromCurrentImageContext()
        button.setBackgroundImage(colorImage, for: .selected)

        UIGraphicsGetCurrentContext()!.setFillColor(UIColor.white.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        button.setBackgroundImage(colorImage, for: .normal)
    }
    
    func subButtonInit() {
        self.backgroundColor = Colors.red
        self.number = -1
        button.setTitle("Sub", for: .normal)
        button.setTitleColor(Colors.red, for: .normal)
    }
    
    @objc func buttonPressed() {
        delegate?.buttonPressed(button: self.button, number: number)
        
    }
}
