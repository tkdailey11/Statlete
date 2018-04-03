//
//  SoccerShotChartEntryView.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerShotChartEntryView: UIControl {
    
    enum ShotType {
        case none
        case goal
        case shotOnGoal
        case shot
    }
    
    var shotTypeSelected: ShotType = .none
    
    var shots: [(loc: CGPoint, type: ShotType)] = [(CGPoint, ShotType)]()
    
    let goalLabel: UILabel = UILabel()
    let shotonGoalLabel: UILabel = UILabel()
    let shotLabel: UILabel = UILabel()
    
    let fontName: String = "Helvetica Neue"
    
    var fieldHeight: CGFloat {
        return bounds.height * 0.7
    }
    
    var shotDimensions: CGFloat {
        return fieldHeight/20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        
        goalLabel.text = "Goal"
        goalLabel.textAlignment = .center
        goalLabel.font = UIFont(name: fontName, size: 12)
        addSubview(goalLabel)
        
        shotonGoalLabel.textAlignment = .center
        shotonGoalLabel.lineBreakMode = .byWordWrapping
        shotonGoalLabel.numberOfLines = 0
        shotonGoalLabel.text = "Shot on Goal"
        shotonGoalLabel.font = UIFont(name: fontName, size: 12)
        addSubview(shotonGoalLabel)
        
        shotLabel.textAlignment = .center
        shotLabel.lineBreakMode = .byWordWrapping
        shotLabel.numberOfLines = 0
        shotLabel.text = "Shot"
        shotLabel.font = UIFont(name: fontName, size: 12)
        addSubview(shotLabel)
    }

    var fieldFrame: CGRect {
        return CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: fieldHeight)
    }
    
    var boxWidth: CGFloat {
        return 6*(bounds.height-fieldHeight)/10
    }
    
    var goalBoxFrame: CGRect {
        return CGRect(x: bounds.minX + bounds.width/10, y: bounds.minY + fieldHeight, width: boxWidth, height: bounds.height - fieldHeight)
    }
    
    var shotBoxFrame: CGRect {
        return CGRect(x: bounds.maxX - (bounds.width/10 + boxWidth), y: bounds.minY + fieldHeight, width: boxWidth, height: bounds.height - fieldHeight)
    }
    
    var shotOnGoalBoxFrame: CGRect {
        return CGRect(x: bounds.midX - boxWidth/2, y: bounds.minY + fieldHeight, width: boxWidth, height: bounds.height - fieldHeight)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // get the context and clear the bounds
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setShouldAntialias(true)
        
        drawField(withContext: context)
        drawFieldLines(WithContext: context)
        drawShotChartSelectors(withContext: context)
        drawShots(withContext: context)
    }
    
    func drawShots(withContext context: CGContext) {
        for shot in shots {
            let loc = shot.loc
            if shot.type == .goal {
                context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
                context.fillEllipse(in: CGRect(x: loc.x - shotDimensions/2, y: loc.y - shotDimensions/2, width: shotDimensions, height: shotDimensions))
            }
            if shot.type == .shotOnGoal {
                context.setFillColor(UIColor.clear.cgColor)
                
                
                /*
                context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
                context.fillEllipse(in: CGRect(x: loc.x - shotDimensions/2, y: loc.y - shotDimensions/2, width: shotDimensions, height: shotDimensions))
                context.setFillColor(UIColor.white.cgColor)
                context.fillEllipse(in: CGRect(x: loc.x - shotDimensions/2, y: loc.y - shotDimensions/2, width: 
                    shotDimensions, height: shotDimensions).insetBy(dx: 2, dy: 2))
                
                */
            }
            if shot.type == .shot {
                context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
                let dimensions = shotDimensions * 0.8
                context.setLineWidth(2.0)
                context.move(to: CGPoint(x: loc.x - dimensions/2, y: loc.y - dimensions/2))
                context.addLine(to: CGPoint(x: loc.x + dimensions/2, y: loc.y + dimensions/2))
                context.move(to: CGPoint(x: loc.x + dimensions/2, y: loc.y - dimensions/2))
                context.addLine(to: CGPoint(x: loc.x - dimensions/2, y: loc.y + dimensions/2))
                context.drawPath(using: .fillStroke)
            }
        }
    }
    
    func drawShotChartSelectors(withContext context: CGContext) {
        // Draw goal selector
        var symbolFrame = CGRect()
        var labelFrame = CGRect()
        (symbolFrame, labelFrame) = goalBoxFrame.divided(atDistance: goalBoxFrame.height/2, from: CGRectEdge.minYEdge)
        
        let dimensions = min(symbolFrame.width, symbolFrame.height) * 0.75
        
        context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
        var circleFrame = CGRect(x: symbolFrame.midX - dimensions/2, y: symbolFrame.maxY - dimensions, width: dimensions, height: dimensions)
        context.fillEllipse(in: circleFrame)
        goalLabel.frame = labelFrame
        
        // Draw Shot on target selector
        (symbolFrame, labelFrame) = shotOnGoalBoxFrame.divided(atDistance: shotOnGoalBoxFrame.height/2, from: CGRectEdge.minYEdge)
        
        context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
        circleFrame = CGRect(x: symbolFrame.midX - dimensions/2, y: symbolFrame.maxY - dimensions, width: dimensions, height: dimensions)
        context.fillEllipse(in: circleFrame)
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: circleFrame.insetBy(dx: 2, dy: 2))
        shotonGoalLabel.frame = labelFrame
        
        // Shot off target selector
        (symbolFrame, labelFrame) = shotBoxFrame.divided(atDistance: shotBoxFrame.height/2, from: CGRectEdge.minYEdge)
        
        context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
        circleFrame = CGRect(x: symbolFrame.midX - dimensions/2, y: symbolFrame.maxY - dimensions, width: dimensions, height: dimensions)
        let offset: CGFloat = dimensions/10
        let topLeftCorner: CGPoint = CGPoint(x: circleFrame.minX + offset, y: circleFrame.minY + offset)
        let topRightCorner: CGPoint = CGPoint(x: circleFrame.maxX - offset, y: circleFrame.minY + offset)
        let bottomRightCorner: CGPoint = CGPoint(x: circleFrame.maxX - offset, y: circleFrame.maxY - offset)
        let bottomLeftCorner: CGPoint = CGPoint(x: circleFrame.minX + offset, y: circleFrame.maxY - offset)
        context.setLineWidth(3.0)
        context.move(to: topLeftCorner)
        context.addLine(to: bottomRightCorner)
        context.move(to: bottomLeftCorner)
        context.addLine(to: topRightCorner)
        context.drawPath(using: .fillStroke)
        shotLabel.frame = labelFrame
    }
    
    func drawField(withContext context: CGContext) {
        context.setFillColor(UIColor(red: 0.0, green: 173.0, blue: 0.0, alpha: 1.0).cgColor)
        context.fill(CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: fieldHeight/4.0))
        context.fill(CGRect(x: bounds.minX, y: bounds.minY + (fieldHeight/2.0), width: bounds.width, height: fieldHeight/4))
        
        context.setFillColor(UIColor(red: 44.0, green: 199.0, blue: 0.0, alpha: 1.0).cgColor)
        context.fill(CGRect(x: bounds.minX, y: bounds.minY + (1*fieldHeight/4.0), width: bounds.width, height: fieldHeight/4.0))
        context.fill(CGRect(x: bounds.minX, y: bounds.minY + (3*fieldHeight/4.0), width: bounds.width, height: fieldHeight/4))
    }
    
    func drawFieldLines(WithContext context: CGContext) {
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.black.cgColor)
        context.move(to: CGPoint(x: bounds.minX, y: bounds.minY + 0.05 * fieldHeight))
        context.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY + 0.05 * fieldHeight))
        
        context.move(to: CGPoint(x: bounds.minX + bounds.width/8, y: bounds.minY + 0.05 * fieldHeight))
        context.addLine(to: CGPoint(x: bounds.minX + bounds.width/8, y: bounds.minY + 0.65 * fieldHeight))
        
        context.move(to: CGPoint(x: bounds.maxX - bounds.width/8, y: bounds.minY + 0.05 * fieldHeight))
        context.addLine(to: CGPoint(x: bounds.maxX - bounds.width/8, y: bounds.minY + 0.65 * fieldHeight))
        
        context.move(to: CGPoint(x: bounds.minX + bounds.width/8, y: bounds.minY + 0.65 * fieldHeight))
        context.addLine(to: CGPoint(x: bounds.maxX - bounds.width/8, y: bounds.minY + 0.65 * fieldHeight))
        
        context.move(to: CGPoint(x: bounds.minX + 0.35 * bounds.width, y: bounds.minY + 0.05 * fieldHeight))
        context.addLine(to: CGPoint(x: bounds.minX + 0.35 * bounds.width, y: bounds.minY + 0.25 * fieldHeight))
        
        context.move(to: CGPoint(x: bounds.minX + 0.65 * bounds.width, y: bounds.minY + 0.05 * fieldHeight))
        context.addLine(to: CGPoint(x: bounds.minX + 0.65 * bounds.width, y: bounds.minY + 0.25 * fieldHeight))
        
        context.move(to: CGPoint(x: bounds.minX + 0.35 * bounds.width, y: bounds.minY + 0.25 * fieldHeight))
        context.addLine(to: CGPoint(x: bounds.minX + 0.65 * bounds.width, y: bounds.minY + 0.25 * fieldHeight))
        
        context.drawPath(using: .fillStroke)
        
        context.setFillColor(UIColor.black.cgColor)
        context.fillEllipse(in: CGRect(x: bounds.midX - 5, y: bounds.minY + 0.40 * fieldHeight, width: 10, height: 10))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first!.location(in: self)
        if goalBoxFrame.contains(loc) {
            shotTypeSelected = .goal
        }
        else if shotOnGoalBoxFrame.contains(loc) {
            shotTypeSelected = .shotOnGoal
        }
        else if shotBoxFrame.contains(loc) {
            shotTypeSelected = .shot
        }
        else if fieldFrame.contains(loc) {
            shots.append((loc, shotTypeSelected))
        }
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
