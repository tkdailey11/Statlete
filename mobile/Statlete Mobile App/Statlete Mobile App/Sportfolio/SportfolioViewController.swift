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
    
    var sportfolios: [String] = ["sportfolio 1", "sportfolio 2", "sportfolio 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        blurView.layer.cornerRadius = 15
        blurView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        viewConstraint.constant = -175
  
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
   
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
