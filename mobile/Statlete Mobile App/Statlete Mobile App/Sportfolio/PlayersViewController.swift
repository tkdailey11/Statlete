//
//  PlayersViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/7/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let players = ["21", "23", "42"]
    var stats: [String: Int] = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
       
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadCollectionView), userInfo: nil, repeats: true)
        stats = ["Assists": 0, "Corners": 0, "Crosses": 0, "Fouls": 0,"Goals": 0,"Minutes": 0,"Offsides": 0,"RedCards": 0,"Saves": 0,"Shots": 0,"Shots on Goal": 0, "Yellow Cards": 0]
        if(DB.currentSportfolio.type == 0){
            // player sportfolio --> change label to say your stats
            
        }else{
            //  getStats(for: "p12")
        }
        
        
    }
    func clearstats(){
        stats = ["Assists": 0, "Corners": 0, "Crosses": 0, "Fouls": 0,"Goals": 0,"Minutes": 0,"Offsides": 0,"RedCards": 0,"Saves": 0,"Shots": 0,"Shots on Goal": 0, "Yellow Cards": 0]
       
    }
    
    @objc func reloadCollectionView() {
        collectionView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DB.currentSportfolio.players.count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as! PlayerCollectionCell
        //cell.numberLabel.text =  players[indexPath.item]
        var playerNumber: String = Array(DB.currentSportfolio.players.keys)[indexPath.row]
        playerNumber.removeFirst()
        cell.numberLabel.text = playerNumber
        return cell
        
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        clearstats()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as! PlayerCollectionCell
     
        var playerNumber: String = Array(DB.currentSportfolio.players.keys)[indexPath.row]
        if(DB.currentSportfolio.type == 1){
        getStats(for: playerNumber)
        }else{
            
        }
        playerNumber.removeFirst()
        cell.numberLabel.text = playerNumber
        // segue
    }
    func getStats(for player: String){
        for game in DB.currentSportfolio.playerStats.keys{
            print(DB.currentSportfolio.playerStats[game])
            print("TYPE: \(type(of: DB.currentSportfolio.playerStats[game]))")
            if let dict =  DB.currentSportfolio.playerStats[game] as? NSDictionary{
                print(dict[player])
                print(type(of:dict[player]))
                if let p = dict[player] as? NSDictionary{
                    print(p)
                    print(type(of: p))
                    print(p["Assists"])
                    print(p["Goals"])
                     print(p["Red Cards"])
                    var val: Int = p["Assists"] as? Int ?? 0
                    stats["Assists"] = stats["Assists"]! + val
                    val = p["Corners"] as? Int ?? 0
                    stats["Corners"] = stats["Corners"]! + val
                    val = p["Crosses"] as? Int ?? 0
                    stats["Crosses"] = stats["Crosses"]! + val
                    val = p["Fouls"] as? Int ?? 0
                    stats["Fouls"] = stats["Fouls"]! + val
                    val = p["Goals"] as? Int ?? 0
                    stats["Goals"] = stats["Goals"]! + val
                    val = p["Offsides"] as? Int ?? 0
                    stats["Offsides"] = stats["Offsides"]! + val
                    val = p["'Red Cards'"] as? Int ?? 0
                    stats["RedCards"] = stats["RedCards"]! + val
                    val = p["Saves"] as? Int ?? 0
                    stats["Saves"] = stats["Saves"]! + val
                    val = p["Shots"] as? Int ?? 0
                    stats["Shots"] = stats["Shots"]! + val
                    val = p["Shots on Goal"] as? Int ?? 0
                    stats["Shots on Goal"] = stats["Shots on Goal"]! + val
                    val = p["Yellow Cards"] as? Int ?? 0
                    stats["Yellow Cards"] = stats["Yellow Cards"]! + val
                }
            }
        }
    }
    func psGetStats(for player: String){
        // for total stats of player sportfolio
        
    }
    
    
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayerCard"{
           let vc = segue.destination as! PlayerInTeamViewController
            vc.statNames = Array(stats.keys)
            vc.statValues = Array(stats.values)
            vc.playerStats = stats
      }
    }
    

}
