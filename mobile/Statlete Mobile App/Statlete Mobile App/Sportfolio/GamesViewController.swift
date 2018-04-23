//
//  GamesViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/7/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var gameToOpen: String = String()

    @IBOutlet weak var newGameButton: UIButton!
    var games: [String] = ["Game 1", "Game2", "Game3"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib.init(nibName: "GameCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GameCell")
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableView), userInfo: nil, repeats: true)
       
        //load players
        
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
        if (!DB.currentSportfolio.admins.contains(DB.currentUser.email.replacingOccurrences(of: ".", with: ""))) {
            newGameButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DB.currentSportfolio.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.commonInit(name: DB.currentSportfolio.games[Array(DB.currentSportfolio.games.keys)[indexPath.row]]!, live: (DB.currentSportfolio.liveGames[Array(DB.currentSportfolio.games.keys)[indexPath.row]] ?? false)!)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        gameToOpen = Array(DB.currentSportfolio.games.keys)[indexPath.row]
        
        
        self.performSegue(withIdentifier: "toVEGamesStatsViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVEGamesStatsViewController" {
            if let controller = segue.destination as? VEGameStatsViewController {
                let sid = DB.currentSportfolio.sportfolioId
                controller.game = SoccerGame(team: sid, gameID: gameToOpen)
                controller.game.loadGameFromDatabase(completion: { success in
                    if success {
                        if (controller.game.live == true) {
                            controller.game.listenForPlayers()
                            controller.game.listenToDatabase()
                        }
                        controller.view.setNeedsDisplay()
                    }
                    else {
                    }
                })
            }
        }
    }
    
    func loadPlayerData(){
        let allgames = DB.currentSportfolio.games.keys
        for game in allgames{
            // iterate through all games add player totals to
            DB.loadPlayerStats(with: game, completion: { success in
                if success {
                    
                }
                else {
                }
            })
        }
    }

}
