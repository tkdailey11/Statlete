//
//  TeamStatView.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/6/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

protocol TeamStatViewDelegate: class {
    func getStatNameAndTeamValues(index: Int) -> (stat: String, myTeamVal: Int, oppTeamVal: Int)
    func getNumberOfStats() -> Int
    func getPossessionValues() -> (myTeamPossession: TimeInterval, oppTeamPossession: TimeInterval)
}

class TeamStatView: UIControl, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView()
    
    weak var delegate: TeamStatViewDelegate?
    
    let myTeamPossessionLabel = UILabel()
    let oppTeamPossessionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.black
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib.init(nibName: "TeamStatCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TeamStatCell")
        
        myTeamPossessionLabel.text = "My Team:"
        myTeamPossessionLabel.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width/2, height: 140)
        myTeamPossessionLabel.textAlignment = .center
        myTeamPossessionLabel.lineBreakMode = .byWordWrapping
        myTeamPossessionLabel.numberOfLines = 0
        myTeamPossessionLabel.textColor = UIColor.white
        addSubview(myTeamPossessionLabel)
        
        oppTeamPossessionLabel.text = "My Team:"
        oppTeamPossessionLabel.frame = CGRect(x: bounds.midX, y: bounds.minY, width: bounds.width/2, height: 140)
        oppTeamPossessionLabel.textAlignment = .center
        oppTeamPossessionLabel.lineBreakMode = .byWordWrapping
        oppTeamPossessionLabel.numberOfLines = 0
        oppTeamPossessionLabel.textColor = UIColor.white
        addSubview(oppTeamPossessionLabel)
        
        tableView.frame = CGRect(x: bounds.minX, y: bounds.minY + 140, width: bounds.width, height: bounds.height - 140)
        addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.getNumberOfStats() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatCell", for: indexPath) as? TeamStatCell {
                cell.headerInit()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatCell", for: indexPath) as? TeamStatCell {
            var statName: String = ""
            var myTeamVal: Int = 0
            var oppTeamVal: Int = 0
            (statName, myTeamVal, oppTeamVal) = delegate!.getStatNameAndTeamValues(index: indexPath.row-1)
            cell.commonInit(stat: statName, myTeamVal: myTeamVal, opposingTeamVal: oppTeamVal)
            return cell
        }
        return UITableViewCell()
    }
    
    func updateLabels() {
        var myTeamPossession: TimeInterval = 0
        var oppTeamPossession: TimeInterval = 0
        (myTeamPossession, oppTeamPossession) = delegate!.getPossessionValues()
        var minute: Int = 0
        var second: Int = 0
        (minute, second) = timeIntervalToMinutesAndSeconds(interval: myTeamPossession)
        myTeamPossessionLabel.text = "My Team: \(getTimeStringFrom(minutes: minute, seconds: second))"
        (minute, second) = timeIntervalToMinutesAndSeconds(interval: oppTeamPossession)
        oppTeamPossessionLabel.text = "Opp Team: \(getTimeStringFrom(minutes: minute, seconds: second))"
    }
    
    func getTimeStringFrom(minutes: Int, seconds: Int) -> String {
        var returnString: String = ""
        if (minutes < 10) {
            returnString.append("0\(minutes)")
        }
        else {
            returnString.append(String(minutes))
        }
        returnString.append(":")
        if (seconds < 10) {
            returnString.append("0\(seconds)")
        }
        else {
            returnString.append(String(seconds))
        }
        return returnString
    }
    
    func timeIntervalToMinutesAndSeconds(interval: TimeInterval) -> (minute: Int, second: Int) {
        var minutes = 0
        var seconds = 0
        let time: Int = Int(interval)
        minutes = time / 60
        seconds = time - (60 * minutes)
        return(minutes, seconds)
    }
}
