//
//  TopBar.swift
//  Soccer
//
//  Created by Nate Gygi on 3/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class TopBar: UIControl {
    
    var gameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.color1
        gameLabel.textColor = UIColor.white
        gameLabel.frame = CGRect(x: bounds.minX + (bounds.width/8), y: bounds.midY - (bounds.height/4), width: 3*bounds.width/4, height: 3.0 / 4.0 * bounds.height)
        gameLabel.textAlignment = .center
        gameLabel.text = ""
        gameLabel.font = UIFont(name: "Helvetica Neue", size: 25)
        addSubview(gameLabel)
    }
    
    func setGameLabel(to label: String) {
        gameLabel.text = label
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
