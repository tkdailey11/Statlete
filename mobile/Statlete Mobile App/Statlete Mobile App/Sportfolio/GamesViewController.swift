//
//  GamesViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/7/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    

    @IBOutlet weak var newGameButton: UIButton!
    var games: [String] = ["Game 1", "Game2", "Game3"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib.init(nibName: "GameCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GameCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.commonInit(name: games[indexPath.row], live: true)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVEGamesStatsViewController" {
            if let controller = segue.destination as? VEGameStatsViewController {
                controller.game = SoccerGame(team: "team2", gameID: "team2-1", name: "vs. Sparta 06", halfLength: 45)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
