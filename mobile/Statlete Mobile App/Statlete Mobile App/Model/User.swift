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
    var phoneNumber: String = String()
    
    var mySportfolios: [String : String] = [String : String]() // hold name and ids
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
       
    }
    
}
