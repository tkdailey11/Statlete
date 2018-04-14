//
//  UserHomeViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/31/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var SportfoliosTitleLabel: UILabel!
    @IBOutlet weak var AddButton: UIButton!
    var dataset: [String] = ["Bulldogs", "Rebels", "REAL"]
    
    var teamSportfolios: [String] = []
    var playerSportfolios: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
     
        let nib = UINib.init(nibName: "SportfolioCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SportfolioCell")
        nameLabel.text = DB.currentUser.name

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Current User: \(DB.currentUser.name)")
        loadSportfolios()
        tableView.reloadData()
    }

    
    func loadSportfolios() {
        for team in DB.currentUser.AdminTeams {
            DB.database.child("TeamSportfolios").child(team).child("TeamName").observeSingleEvent(of: .value, with: { (snapshot) in
                self.teamSportfolios.append(snapshot.value as? String ?? "")
                self.tableView.reloadData()
            })
        }
        for team in DB.currentUser.PlayerTeams {
            DB.database.child("PlayerSportfolios").child(team).child("Name").observeSingleEvent(of: .value, with: { (snapshot) in
                print("SNAPSHOT!!!!!!!!!!!        !!!!: \(snapshot)")
                self.playerSportfolios.append(snapshot.value as? String ?? "")
                self.tableView.reloadData()
            })
        }
        /*
        for team in DB.currentUser.PlayerTeams {
            DB.database.child("PlayerSportfolios").child(team).child("Name").observeSingleEvent(of: .value, with: { (snapshot) in
                self.playerSportfolios.append(snapshot.value as? String ?? "")
                self.tableView.reloadData()
            })
        }
 */
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamSportfolios.count + playerSportfolios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportfolioCell", for: indexPath) as! SportfolioCell
        if indexPath.row < teamSportfolios.count {
            cell.commonInit(imageName: "soccer", name: teamSportfolios[indexPath.row])
        }
        else {
            cell.commonInit(imageName: "soccer", name: playerSportfolios[indexPath.row-teamSportfolios.count])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    

}


