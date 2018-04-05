//
//  StatView.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/5/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class StatView: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.black
    
    }
    
    
}
