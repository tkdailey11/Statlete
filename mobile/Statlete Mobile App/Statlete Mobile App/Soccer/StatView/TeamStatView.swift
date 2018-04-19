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
        
        let possessionLabel = UILabel()
        possessionLabel.text = "Possession"
        possessionLabel.textAlignment = .center
        possessionLabel.frame = CGRect(x: bounds.midX - 50, y: bounds.minY, width: 100, height: 40)
        possessionLabel.textColor = UIColor.white
        addSubview(possessionLabel)
        
        myTeamPossessionLabel.text = ""
        myTeamPossessionLabel.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width/2 - 50, height: 40)
        myTeamPossessionLabel.textAlignment = .right
        myTeamPossessionLabel.textColor = UIColor.white
        addSubview(myTeamPossessionLabel)
        
        oppTeamPossessionLabel.text = ""
        oppTeamPossessionLabel.frame = CGRect(x: bounds.midX + 50, y: bounds.minY, width: bounds.width/2 - 50, height: 40)
        oppTeamPossessionLabel.textAlignment = .left
        oppTeamPossessionLabel.textColor = UIColor.white
        addSubview(oppTeamPossessionLabel)
        
        tableView.frame = CGRect(x: bounds.minX, y: bounds.minY + 120, width: bounds.width, height: bounds.height - 120)
        tableView.backgroundColor = UIColor.black
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
        var myMinute: Int = 0
        var mySecond: Int = 0
        var oppMinute: Int = 0
        var oppSecond: Int = 0
        (myMinute, mySecond) = timeIntervalToMinutesAndSeconds(interval: myTeamPossession)
        (oppMinute, oppSecond) = timeIntervalToMinutesAndSeconds(interval: oppTeamPossession)
        let myTeamSeconds: Int = 60 * myMinute + mySecond
        let oppTeamSeconds: Int = 60 * oppMinute + oppSecond
        var myTeamPercent: Int = 0
        var oppTeamPercent: Int = 0
        if !(myTeamSeconds == 0 && oppTeamSeconds == 0) {
            myTeamPercent = Int(100 * (CGFloat(myTeamSeconds)/CGFloat((myTeamSeconds + oppTeamSeconds))))
            oppTeamPercent = 100 - myTeamPercent
        }
        myTeamPossessionLabel.text = "(\(getTimeStringFrom(minutes: myMinute, seconds: mySecond))) \(myTeamPercent)%"
        oppTeamPossessionLabel.text = "\(oppTeamPercent)% (\(getTimeStringFrom(minutes: oppMinute, seconds: oppSecond)))"
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
        let time = Int(interval)
        minutes = time / 60
        seconds = time - (60 * minutes)
        return(minutes, seconds)
    }
}
