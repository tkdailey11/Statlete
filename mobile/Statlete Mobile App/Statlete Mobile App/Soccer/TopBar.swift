//
//  TopBar.swift
//  Soccer
//
//  Created by Nate Gygi on 3/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

protocol TopBarDelegate: class {
    func backButtonClicked()
}

class TopBar: UIControl {
    
    let backButton = UIButton()
    let gameLabel: UILabel = UILabel()
    
    weak var delegate: TopBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        gameLabel.textColor = Colors.color2
        gameLabel.frame = CGRect(x: bounds.minX + (bounds.width/4), y: bounds.midY - (bounds.height/4), width: bounds.width/2, height: 3.0 / 4.0 * bounds.height)
        gameLabel.textAlignment = .center
        gameLabel.text = ""
        gameLabel.font = UIFont(name: "Helvetica Neue", size: 25)
        addSubview(gameLabel)
        
        backButton.backgroundColor = UIColor.white
        backButton.setTitleColor(Colors.color2, for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.setTitle("Back", for: .normal)
        backButton.frame = CGRect(x: bounds.minX, y: bounds.maxY-30, width: 55, height: 30)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        addSubview(backButton)
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonClicked()
    }
    
    func setGameLabel(to label: String) {
        gameLabel.text = label
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
