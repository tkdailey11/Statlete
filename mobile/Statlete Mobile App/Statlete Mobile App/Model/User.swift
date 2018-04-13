//
//  User.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/7/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation

class User {
    
    public var name: String = String()
    private var email: String = String()
    private var AdminTeams: [String] = [String]() // list of sportfolio ids
    private var PlayerTeams: [String] = [String]()
    private var phoneNumber: String = String()
    
    private let mySportfolios: [Sportfolio] = [Sportfolio]()
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
       
    }
    
}
