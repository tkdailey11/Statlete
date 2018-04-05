//
//  SoccerTeamEntryView.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class SoccerTeamEntryView: UIControl {
    
    let statHeight: CGFloat = 60.0
    var horizontalMargin: CGFloat {
        return bounds.width/10
    }
    var verticalMargin: CGFloat {
        return statHeight/6
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // get the context and clear the bounds
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setFillColor(UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0).cgColor)
        for i in 0...3 {
            let minusButton: UIButton = UIButton(type: .custom)
            minusButton.backgroundColor = UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0)
            minusButton.frame = getMinusButtonFrameAtIndex(index: i)
            minusButton.layer.cornerRadius = 0.5 * minusButton.bounds.width
            minusButton.clipsToBounds = true
            minusButton.setTitleColor(UIColor.white, for: .normal)
            minusButton.setTitle("-", for: .normal)
            minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
            addSubview(minusButton)
            
            let plusButton: UIButton = UIButton(type: .custom)
            plusButton.backgroundColor = UIColor(red: 108.0/255.0, green: 12.0/255.0, blue: 12.0/255.0, alpha: 1.0)
            plusButton.frame = getPlusButtonFrameAtIndex(index: i)
            plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.width
            plusButton.clipsToBounds = true
            plusButton.setTitleColor(UIColor.white, for: .normal)
            plusButton.setTitle("+", for: .normal)
            plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
            addSubview(plusButton)
        }
    }
    
    @objc func minusButtonPressed() {
        print("Minus Pressed")
    }
    
    
    @objc func plusButtonPressed() {
        print("Plus Pressed")
    }
    
    func getMinusButtonFrameAtIndex(index: Int) -> CGRect {
        return CGRect(x: bounds.minX + horizontalMargin, y: bounds.minY + CGFloat(index) * statHeight + verticalMargin, width: statHeight - 2 * verticalMargin, height: statHeight - 2 * verticalMargin)
    }
    
    func getPlusButtonFrameAtIndex(index: Int) -> CGRect {
        return CGRect(x: bounds.maxX - (horizontalMargin + statHeight - 2 * verticalMargin), y: bounds.minY + CGFloat(index) * statHeight + verticalMargin, width: statHeight - 2 * verticalMargin, height: statHeight - 2 * verticalMargin)
    }
        
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
}
