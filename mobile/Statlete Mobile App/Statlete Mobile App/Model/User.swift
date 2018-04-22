//
//  User.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/7/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation

class User {
    
    var name: String = String()
    var email: String = String()
    var AdminTeams: [String] = [String]() // list of sportfolio ids
    var PlayerTeams: [String] = [String]()
    var PlayerSportfolios: [String: String] = [String : String]() // id - linkedteamid (empty if not linked)
    var phoneNumber: String = String()
    var linkedTeams: [String: String] = [String : String]() // player sportfolios linked to team
    
    var mySportfolios: [String : String] = [String : String]() // ID as key, NAME as value
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
       
    }
    
}
