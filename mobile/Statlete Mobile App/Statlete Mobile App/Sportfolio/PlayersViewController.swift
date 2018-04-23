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
    let stats: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
       
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadCollectionView), userInfo: nil, repeats: true)
        if(DB.currentSportfolio.type == 0){
            // player sportfolio --> change label to say your stats
        }else{
            
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as! PlayerCollectionCell
     
        var playerNumber: String = Array(DB.currentSportfolio.players.keys)[indexPath.row]
        playerNumber.removeFirst()
        cell.numberLabel.text = playerNumber
        // segue
    }
    func getStats(for player: String){
      //stats = DB.currentSportfolio.playerStats
    }
    func psGetStats(for player: String){
        
    }
    
    
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     //   if segue.identifier == "toPlayerCard"{
     //       let vc = segue.destination as! PlayerInTeamViewController
          //  vc.playerStats =
     //   }
    }
    

}
