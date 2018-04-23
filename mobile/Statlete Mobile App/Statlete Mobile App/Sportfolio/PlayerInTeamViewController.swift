//
//  PlayerInTeamViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerInTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func dismissPopup(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    var playerStats: [String: Int] = [:]
    var statNames: [String] = []
    var statValues: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
     //   statNames = ArrayplayerStats.keys
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return playerStats.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerTotalsCell", for: indexPath) as! PlayerTotalsCell
        cell.statNameLabel.text  = statNames[indexPath.row]
        cell.statValueLabel.text = "\(statValues[indexPath.row])"
        return cell
    }

    

}
