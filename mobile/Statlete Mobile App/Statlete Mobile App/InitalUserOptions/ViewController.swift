//
//  ViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/6/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ViewExistingTeamButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var CreateAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LoginButton.layer.borderWidth = 0.8
        LoginButton.layer.borderColor = UIColor.red.cgColor
        CreateAccountButton.layer.borderWidth = 0.8
        CreateAccountButton.layer.borderColor = UIColor.red.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

