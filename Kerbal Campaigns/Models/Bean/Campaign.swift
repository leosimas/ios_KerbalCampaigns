//
//  Campaign.swift
//  Kerbal Campaigns
//
//  Created by SSA on 15/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import RealmSwift

class Campaign : Object {
    
    dynamic var id = ""
    dynamic var completed : Bool = false
    dynamic var name = ""
    dynamic var difficulty = ""
    dynamic var introduction = ""
    dynamic var length = ""
    dynamic var difficultyNumber = 1
    dynamic var difficultyText = ""
    let missions = List<Mission>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
