//
//  UserHomeViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/31/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit
import Firebase

class UserHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            do{
                try Auth.auth().signOut()
                DB.currentUser = User(name: "", email: "")
                self.performSegue(withIdentifier: "toBeginning", sender: nil)
                
                
            }catch let signOutError as NSError{
                print("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var SportfoliosTitleLabel: UILabel!
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    var teamSportfolios: [String] = []
    var playerSportfolios: [String] = []
    //var playerSportfolios: [String:String] = [:]
    var selectedSportfolioName: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       
        self.nameLabel.text = DB.currentUser.name
       // loadViewIfNeeded()
    //    profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        
        profileImage.layer.shadowColor = UIColor.black.cgColor
        profileImage.layer.shadowOpacity = 0.8
        profileImage.layer.shadowOffset = CGSize(width: 5, height: 0)
        
      //  profileImage.layer.borderColor = UIColor.red.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
      
        let nib = UINib.init(nibName: "SportfolioCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SportfolioCell")
     

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
    }
    func logout(){
        // do alert, when click logout call this 
        // firebase.auth.logout?
        /*let alert = UIAlertController(title: "Start Game?", message: "", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
         DB.database.child("SoccerGames").child(self.game.id).updateChildValues(["PeriodStartTime": Int(Date().timeIntervalSince1970)])
         DB.database.child("SoccerGames").child(self.game.id).updateChildValues(["InProgress": true])
         
         }))
         alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
         self.present(alert, animated: true)*/
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
        self.nameLabel.text = DB.currentUser.name
        teamSportfolios = []
        playerSportfolios = []
        DB.currentUser.mySportfolios = [:]
        for team in DB.currentUser.AdminTeams {
            DB.database.child("TeamSportfolios").child(team).child("TeamName").observeSingleEvent(of: .value, with: { (snapshot) in
                let teamname = snapshot.value as? String ?? ""
                self.teamSportfolios.append(teamname)
                if !teamname.isEmpty{
                   // DB.currentUser.sportfolioNames.append(teamname)
                    DB.currentUser.mySportfolios[teamname] = team
                }
                self.tableView.reloadData()
            })
         
        }
        for team in DB.currentUser.PlayerSportfolios.keys {
            DB.database.child("PlayerSportfolios").child(team).child("Name").observeSingleEvent(of: .value, with: { (snapshot) in
                print("SNAPSHOT!!!!!!!!!!!        !!!!: \(snapshot)")
                let teamname = snapshot.value as? String ?? ""
                self.playerSportfolios.append(teamname)
                //self.playerSportfolios[team] = teamname
                if !teamname.isEmpty{
                     DB.currentUser.mySportfolios[teamname] = team
                   // DB.currentUser.sportfolioNames.append(teamname)
                }
                
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! SportfolioCell
        selectedSportfolioName = cell.nameLabel.text!
        
        // get info from db and segue
        
        self.performSegue(withIdentifier: "toSelectSportfolio", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectSportfolio"{
            let vc = segue.destination as! SportfolioViewController
            print("i am preparing")
            var sid: String = String()
          
            if(DB.currentUser.mySportfolios.keys.contains(selectedSportfolioName)){
                sid = DB.currentUser.mySportfolios[selectedSportfolioName]! // get id from name
            }
            
            if(playerSportfolios.contains(selectedSportfolioName)){
                // search db in PlayerSportfolio
                 print("selected is contained in PLAYER SPORTFOLIOOOOOO")
                // check if linked to team
                if(DB.currentUser.PlayerSportfolios[sid] == "NA"){
                    DB.loadPlayerSportfolio(with: sid, completion: {success in
                        if success{
                             vc.thisSportfolio = DB.currentSportfolio
                            vc.view.setNeedsDisplay()
                            for game in DB.currentSportfolio.games.keys{
                                DB.loadPlayerStats(with: game, completion: { success in
                                    if success{
                                        
                                    }
                                    else{
                                        
                                    }
                                })
                            }
                        }else{
                            
                        }
                    })
                }else{
                    sid = DB.currentUser.PlayerSportfolios[sid]! // get teamid 
                    DB.loadTeamSportfolio(with: sid, completion: { success in
                        if success {
                            vc.thisSportfolio = DB.currentSportfolio
                            vc.view.setNeedsDisplay()
                        }
                        else {
                        }
                    })
                }
                
                
            }else if(teamSportfolios.contains(selectedSportfolioName)){
                print("selected is contained in TEAM SPORTFOLIOOOOOO")
                DB.loadTeamSportfolio(with: sid, completion: { success in
                    if success {
                        vc.thisSportfolio = DB.currentSportfolio
                        vc.view.setNeedsDisplay()
                        for game in DB.currentSportfolio.games.keys{
                            DB.loadPlayerStats(with: game, completion: { success in
                                if success{
                                    
                                }
                                else{
                                    
                                }
                            })
                        }
                    }
                    else {
                    }
                })
                
            }
            
            
            //////////////////////
           /* DB.loadTeamSportfolio(with: sid, completion: { success in
                if success {
                    vc.thisSportfolio = DB.currentSportfolio
                    vc.view.setNeedsDisplay()
                }
                else {
                }
            })*/
            //////////////////////
           
       //   vc.thisSportfolio = Sportfolio(sportfolioId: sid, name: selectedSportfolioName, games: games, players: <#T##[String : [String : String]]#>, playerStats: <#T##[String : [String : Int]]#>)
            // get games from db
            // get other stuff from db 
        }
        
    }
    

}

final class HomeGradientView: UIView{
    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: superview!.frame.size.width, height: superview!.frame.size.height)
        gradient.colors = [Colors.orange.cgColor, Colors.lightyellow.cgColor]
        gradient.zPosition = -1
        
        layer.addSublayer(gradient)
    }
}




