//
//  BottomBar.swift
//  Soccer
//
//  Created by Nate Gygi on 3/22/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class BottomBar: UIControl {
    
    var tabSelected: Int = 1
    
    
    /// Change these to images
    let tab1Label = UILabel()
    let tab2Label = UILabel()
    let tab3Label = UILabel()
    /////
    
    var tab1Frame: CGRect {
        return CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width/3, height: bounds.height)
    }
    
    var tab2Frame: CGRect {
        return CGRect(x: bounds.minX + bounds.width/3, y: bounds.minY, width: bounds.width/3, height: bounds.height)
    }
    
    var tab3Frame: CGRect {
        return CGRect(x: bounds.minX + (2*bounds.width/3), y: bounds.minY, width: bounds.width/3, height: bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.red
        
        //////////
        tab1Label.frame = tab1Frame
        tab1Label.text = "Entry"
        tab1Label.textAlignment = .center
        tab1Label.textColor = UIColor.white
        addSubview(tab1Label)
        
        tab2Label.frame = tab2Frame
        tab2Label.text = "Shot Chart"
        tab2Label.textAlignment = .center
        tab2Label.textColor = UIColor.white
        addSubview(tab2Label)
        
        tab3Label.frame = tab3Frame
        tab3Label.text = "Stats"
        tab3Label.textAlignment = .center
        tab3Label.textColor = UIColor.white
        addSubview(tab3Label)
        //////////
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first!.location(in: self)
        if tab1Frame.contains(loc) {
            if tabSelected != 1 {
                tabSelected = 1
                sendActions(for: .valueChanged)
            }
        }
        else if tab2Frame.contains(loc) {
            if tabSelected != 2 {
                tabSelected = 2
                sendActions(for: .valueChanged)
            }
        }
        else if tab3Frame.contains(loc) {
            if tabSelected != 3 {
                tabSelected = 3
                sendActions(for: .valueChanged)
            }
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
