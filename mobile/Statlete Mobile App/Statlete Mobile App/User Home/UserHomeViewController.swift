//
//  UserHomeViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/31/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var SportfoliosTitleLabel: UILabel!
    @IBOutlet weak var AddButton: UIButton!
    var dataset: [String] = ["Bulldogs", "Rebels", "REAL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
       
        
        let nib = UINib.init(nibName: "SportfolioCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SportfolioCell")
        
        print("Current User: \(DB.currentUser.name)")
    
       
  //  tableView.register(SportfolioCellTableViewCell.nib, forCellReuseIdentifier: "SportfolioCellTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataset.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportfolioCell", for: indexPath) as! SportfolioCell
        cell.commonInit(imageName: "soccer", name: dataset[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Current User: \(DB.currentUser.name)")
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


