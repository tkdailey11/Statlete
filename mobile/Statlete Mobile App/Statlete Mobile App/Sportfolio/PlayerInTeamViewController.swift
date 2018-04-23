//
//  PlayerInTeamViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerInTeamViewController: UIViewController {

    @IBAction func dismissPopup(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    var playerStats: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // table view

    

}
