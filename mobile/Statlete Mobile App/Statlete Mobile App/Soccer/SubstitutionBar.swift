//
//  SubstitutionBar.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SubstitutionBar: UIControl {
    
    let fontName: String = "Helvetica Neue"
    
    var opposingTeamFrame: CGRect {
        return CGRect(x: bounds.minX, y: bounds.minY, width: 1.5 * bounds.height, height: bounds.height)
    }
    
    let opposingTeamLabel: UILabel = UILabel()
    
    //////
    let player1Label = UILabel()
    let player2Label = UILabel()
    let player3Label = UILabel()
    let player4Label = UILabel()
    let player5Label = UILabel()
    //////
    
    var opposingTeamCircleFrame: CGRect {
        return CGRect(x: opposingTeamFrame.minX + opposingTeamFrame.width/6, y: opposingTeamFrame.minY, width: opposingTeamFrame.height, height: opposingTeamFrame.height).insetBy(dx: bounds.height/10, dy: bounds.height/10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        
        // opposing team label
        opposingTeamLabel.frame = opposingTeamCircleFrame
        opposingTeamLabel.textAlignment = .center
        opposingTeamLabel.lineBreakMode = .byWordWrapping
        opposingTeamLabel.numberOfLines = 0
        opposingTeamLabel.text = "Opp. Team"
        opposingTeamLabel.font = UIFont(name: fontName, size: 12)
        addSubview(opposingTeamLabel)
        
        ////////
        player1Label.frame = getPlayerCircleFrame(forIndex: 0)
        player1Label.textAlignment = .center
        player1Label.text = "#1"
        player1Label.font = UIFont(name: fontName, size: 18)
        addSubview(player1Label)
        
        
        player2Label.frame = getPlayerCircleFrame(forIndex: 1)
        player2Label.textAlignment = .center
        player2Label.text = "#2"
        player2Label.font = UIFont(name: fontName, size: 18)
        addSubview(player2Label)
        
        player3Label.frame = getPlayerCircleFrame(forIndex: 2)
        player3Label.textAlignment = .center
        player3Label.text = "#3"
        player3Label.font = UIFont(name: fontName, size: 18)
        addSubview(player3Label)
        
        player4Label.frame = getPlayerCircleFrame(forIndex: 3)
        player4Label.textAlignment = .center
        player4Label.text = "#4"
        player4Label.font = UIFont(name: fontName, size: 18)
        addSubview(player4Label)
        
        player5Label.frame = getPlayerCircleFrame(forIndex: 4)
        player5Label.textAlignment = .center
        player5Label.text = "#5"
        player5Label.font = UIFont(name: fontName, size: 18)
        addSubview(player5Label)
        ////////
        
        
    }
    
    func getPlayerCircleFrame(forIndex index: Int) -> CGRect {
        return CGRect(x: bounds.minX + opposingTeamFrame.width + CGFloat(index) * bounds.height, y: bounds.minY, width: bounds.height, height: bounds.height).insetBy(dx: bounds.height/10, dy: bounds.height/10)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // get the context and clear the bounds
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
        context.fillEllipse(in: opposingTeamCircleFrame)
        
        /////////
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: getPlayerCircleFrame(forIndex: 0))
        context.fillEllipse(in: getPlayerCircleFrame(forIndex: 1))
        context.fillEllipse(in: getPlayerCircleFrame(forIndex: 2))
        context.fillEllipse(in: getPlayerCircleFrame(forIndex: 3))
        context.fillEllipse(in: getPlayerCircleFrame(forIndex: 4))
        /////////
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
