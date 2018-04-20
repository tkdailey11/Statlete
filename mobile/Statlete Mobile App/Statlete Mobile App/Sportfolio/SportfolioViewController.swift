//
//  SportfolioViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class SportfolioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var sportfolioNameLabel: UILabel!
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var isSideMenuHidden: Bool = true
    var thisSportfolio: Sportfolio = Sportfolio() // names to display
    
    var sportfolios: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        blurView.layer.cornerRadius = 15
        blurView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        viewConstraint.constant = -175
        sportfolios = Array(DB.currentUser.mySportfolios.keys)
  
    }
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        if(isSideMenuHidden){
            viewConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
            pageView.isUserInteractionEnabled = false
        } else{
            viewConstraint.constant = -175
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
            pageView.isUserInteractionEnabled = true
        }
        isSideMenuHidden = !isSideMenuHidden
    }
    
   
    /*
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let locationx = sender.location(in: view).x
  
        if(isSideMenuHidden){
            
        }else{
            if(locationx < 175){
                print("inside bounds of slide menu")
            }else{
                viewConstraint.constant = -175
                viewConstraint.constant = -175
                UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
                pageView.isUserInteractionEnabled = true
                isSideMenuHidden = !isSideMenuHidden
            }
        }
        print("touched")
    }
    */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportfolios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = sportfolios[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
   
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
