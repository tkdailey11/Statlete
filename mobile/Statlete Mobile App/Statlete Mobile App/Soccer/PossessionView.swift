//
//  PossessionView.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class PossessionView: UIControl {
    
    enum Selected {
        case myTeam
        case oppTeam
        case out
    }
    
    let textFont = UIFont(name: "Helvetica", size: 24)
    
    var currentlySelected: Selected = .myTeam
    
    let possessionLabel: UILabel = UILabel()
    
    var myTeamPossessionLabel = UILabel()
    var outOfPlayPossessionLabel = UILabel()
    var opposingTeamPossessionLabel = UILabel()
    
    var boxWidth: CGFloat {
        return 6*bounds.height/10
    }
    
    var myTeamPossessionBoxFrame: CGRect {
        return CGRect(x: bounds.minX + bounds.width/10, y: bounds.minY + boxWidth/2, width: boxWidth, height: boxWidth)
    }
    
    var opposingTeamPossessionBoxFrame: CGRect {
        return CGRect(x: bounds.maxX - (bounds.width/10 + boxWidth), y: bounds.minY + boxWidth/2, width: boxWidth, height: boxWidth)
    }
    
    var outOfPlayPossessionBoxFrame: CGRect {
        return CGRect(x: bounds.midX - boxWidth/2, y: bounds.minY + boxWidth/2, width: boxWidth, height: boxWidth)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        possessionLabel.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height/4)
        possessionLabel.textAlignment = .center
        possessionLabel.text = "Possession"
        addSubview(possessionLabel)
        
        myTeamPossessionLabel.frame = myTeamPossessionBoxFrame
        myTeamPossessionLabel.textAlignment = .center
        myTeamPossessionLabel.lineBreakMode = .byWordWrapping
        myTeamPossessionLabel.numberOfLines = 0
        myTeamPossessionLabel.text = "My Team"
        myTeamPossessionLabel.font = textFont
        addSubview(myTeamPossessionLabel)
        
        opposingTeamPossessionLabel.frame = opposingTeamPossessionBoxFrame
        opposingTeamPossessionLabel.textAlignment = .center
        opposingTeamPossessionLabel.lineBreakMode = .byWordWrapping
        opposingTeamPossessionLabel.numberOfLines = 0
        opposingTeamPossessionLabel.text = "Opp. Team"
        opposingTeamPossessionLabel.font = textFont
        addSubview(opposingTeamPossessionLabel)
        
        outOfPlayPossessionLabel.frame = outOfPlayPossessionBoxFrame
        outOfPlayPossessionLabel.textAlignment = .center
        outOfPlayPossessionLabel.lineBreakMode = .byWordWrapping
        outOfPlayPossessionLabel.numberOfLines = 0
        outOfPlayPossessionLabel.text = "Out"
        outOfPlayPossessionLabel.font = textFont
        addSubview(outOfPlayPossessionLabel)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // get the context and clear the bounds
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // Draw myTeam
        context.setFillColor(Colors.color2.cgColor)
        context.setLineWidth(3)
        
        if currentlySelected == .myTeam {
            context.setStrokeColor(UIColor.black.cgColor)
            myTeamPossessionLabel.textColor = UIColor.white
        }
        else {
            context.setStrokeColor(Colors.color2.cgColor)
            myTeamPossessionLabel.textColor = UIColor.black
        }
        context.addPath(CGPath(roundedRect: myTeamPossessionBoxFrame, cornerWidth: 20, cornerHeight: 20, transform: nil))
        context.drawPath(using: .eoFillStroke)
        
        // Draw oppTeam
        if currentlySelected == .oppTeam {
            context.setStrokeColor(UIColor.black.cgColor)
            opposingTeamPossessionLabel.textColor = UIColor.white
        }
        else {
            context.setStrokeColor(Colors.color2.cgColor)
            opposingTeamPossessionLabel.textColor = UIColor.black
        }
        context.addPath(CGPath(roundedRect: opposingTeamPossessionBoxFrame, cornerWidth: 20, cornerHeight: 20, transform: nil))
        context.drawPath(using: .eoFillStroke)
        
        // Draw out of Play
        if currentlySelected == .out {
            context.setStrokeColor(UIColor.black.cgColor)
            
            outOfPlayPossessionLabel.textColor = UIColor.white
        }
        else {
            context.setStrokeColor(Colors.color2.cgColor)
            outOfPlayPossessionLabel.textColor = UIColor.black
        }
        context.addPath(CGPath(roundedRect: outOfPlayPossessionBoxFrame, cornerWidth: 20, cornerHeight: 20, transform: nil))
        context.drawPath(using: .eoFillStroke)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first!.location(in: self)
        if myTeamPossessionBoxFrame.contains(loc) {
            currentlySelected = .myTeam
        }
        if opposingTeamPossessionBoxFrame.contains(loc) {
            currentlySelected = .oppTeam
        }
        if outOfPlayPossessionBoxFrame.contains(loc) {
            currentlySelected  = .out
        }
        setNeedsDisplay()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
