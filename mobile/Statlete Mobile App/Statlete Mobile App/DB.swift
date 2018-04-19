//
//  DB.swift
//  Statlete Mobile App
//
//  Created by Nate Gygi on 4/12/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import Foundation
import Firebase

class DB {
    
    public static var currentUser: User = User(name: "", email: "")
    public static var database: DatabaseReference = DatabaseReference()
    public static var currentSportfolio = Sportfolio()
    
}
