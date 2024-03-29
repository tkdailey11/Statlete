//
//  ScoreboardView.swift
//  Soccer
//
//  Created by Nate Gygi on 3/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class ScoreboardView: UIControl {
    
    
    
    let myTeamScoreLabel: UILabel = UILabel()
    let opposingTeamScoreLabel: UILabel = UILabel()
    let timeLabel: UILabel = UILabel()
    let firstHalfLabel: UILabel = UILabel()
    let secondHalfLabel: UILabel = UILabel()
    var firstHalfCircleBounds: CGRect = CGRect()
    var firstHalfLabelBounds: CGRect = CGRect()
    var secondHalfCircleBounds: CGRect = CGRect()
    var secondHalfLabelBounds: CGRect = CGRect()
    let fontName: String = "Helvetica Neue"
    var game: Game
    
    var timeBox: CGRect {
        return CGRect(x: bounds.midX - bounds.width / 5, y: bounds.minY + 10, width: 2 * bounds.width/5, height: bounds.height - 20)
    }
    
    var firstHalfBounds: CGRect {
        return CGRect(x: bounds.minX + bounds.width/5, y: bounds.minY + 10, width: bounds.width/10, height: bounds.height - 20)
    }
    
    var secondHalfBounds: CGRect {
        return CGRect(x: bounds.maxX - 3 * bounds.width/10, y: bounds.minY + 10, width: bounds.width/10, height: bounds.height - 20)
    }
    
    init(frame: CGRect, game: Game) {
        self.game = game
        super.init(frame: frame)
        setupDisplay()
    }
    
    func setupDisplay() {
        backgroundColor = UIColor.white
        
        // myTeamLabel
        myTeamScoreLabel.text = "\(game.myTeamScore)"
        myTeamScoreLabel.font = UIFont(name: fontName, size: 60)
        myTeamScoreLabel.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width/5, height: bounds.height)
        myTeamScoreLabel.textAlignment = .center
        addSubview(myTeamScoreLabel)
        
        // opposingTeamLabel
        opposingTeamScoreLabel.text = "\(game.opposingTeamScore)"
        opposingTeamScoreLabel.font = UIFont(name: fontName, size: 60)
        opposingTeamScoreLabel.frame = CGRect(x: bounds.maxX - bounds.width/5, y: bounds.minY, width: bounds.width/5, height: bounds.height)
        opposingTeamScoreLabel.textAlignment = .center
        addSubview(opposingTeamScoreLabel)
        
        // timeLabel
        timeLabel.text = "34:55"
        timeLabel.font = UIFont(name: fontName, size: 36)
        timeLabel.frame = timeBox
        timeLabel.textAlignment = .center
        addSubview(timeLabel)
        
        addSubview(firstHalfLabel)
        firstHalfLabel.text = "1"
        firstHalfLabel.textAlignment = .center
        firstHalfLabel.font = UIFont(name: fontName, size: 24)
        
        addSubview(secondHalfLabel)
        secondHalfLabel.text = "2"
        secondHalfLabel.textAlignment = .center
        secondHalfLabel.font = UIFont(name: fontName, size: 24)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        context.fill(timeBox)
        context.setFillColor(UIColor.white.cgColor)
        context.fill(timeBox.insetBy(dx: 2, dy: 2))
        
        myTeamScoreLabel.text = "\(game.myTeamScore)"
        opposingTeamScoreLabel.text = "\(game.opposingTeamScore)"
        
        
        // Draw First Half Circle and Label
        (firstHalfCircleBounds, firstHalfLabelBounds) = firstHalfBounds.divided(atDistance: firstHalfBounds.height/2, from: CGRectEdge.minYEdge)
        context.setFillColor(UIColor.black.cgColor)
        if firstHalfCircleBounds.width < firstHalfCircleBounds.height {
            let circleWidth: CGFloat = firstHalfCircleBounds.width * 0.8
            let circleBounds: CGRect = CGRect(x: firstHalfCircleBounds.midX - circleWidth / 2, y: firstHalfCircleBounds.maxY - circleWidth, width: circleWidth, height: circleWidth)
            context.fillEllipse(in:circleBounds)
            if game.half == 2 {
                context.setFillColor(UIColor.white.cgColor)
                context.fillEllipse(in:circleBounds.insetBy(dx: 2, dy: 2))
            }
        }
        else {
            let circleWidth: CGFloat = firstHalfCircleBounds.height * 0.8
            let circleBounds: CGRect = CGRect(x: firstHalfCircleBounds.midX - circleWidth / 2, y: firstHalfCircleBounds.maxY - circleWidth, width: circleWidth, height: circleWidth)
            context.fillEllipse(in:circleBounds)
            if game.half == 2 {
                context.setFillColor(UIColor.white.cgColor)
                context.fillEllipse(in:circleBounds.insetBy(dx: 2, dy: 2))
            }
        }
        firstHalfLabel.frame = firstHalfLabelBounds
        
        // Draw Second Half Circle and Label
        (secondHalfCircleBounds, secondHalfLabelBounds) = secondHalfBounds.divided(atDistance: secondHalfBounds.height/2, from: CGRectEdge.minYEdge)
        context.setFillColor(UIColor.black.cgColor)
        if secondHalfCircleBounds.width < secondHalfCircleBounds.height {
            let circleWidth: CGFloat = secondHalfCircleBounds.width * 0.8
            let circleBounds: CGRect = CGRect(x: secondHalfCircleBounds.midX - circleWidth / 2, y: secondHalfCircleBounds.maxY - circleWidth, width: circleWidth, height: circleWidth)
            context.fillEllipse(in:circleBounds)
            if game.half == 1 {
                context.setFillColor(UIColor.white.cgColor)
                context.fillEllipse(in:circleBounds.insetBy(dx: 2, dy: 2))
            }
        }
        else {
            let circleWidth: CGFloat = secondHalfCircleBounds.height * 0.8
            let circleBounds: CGRect = CGRect(x: secondHalfCircleBounds.midX - circleWidth / 2, y: secondHalfCircleBounds.maxY - circleWidth, width: circleWidth, height: circleWidth)
            context.fillEllipse(in:circleBounds)
            if game.half == 1 {
                context.setFillColor(UIColor.white.cgColor)
                context.fillEllipse(in:circleBounds.insetBy(dx: 2, dy: 2))
            }
        }
        secondHalfLabel.frame = secondHalfLabelBounds
        
    }
    
    //// Required Initializer ////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

