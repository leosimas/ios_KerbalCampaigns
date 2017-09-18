//
//  Task.swift
//  Kerbal Campaigns
//
//  Created by SSA on 15/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import RealmSwift

class Task : Object {
    
    dynamic var id = ""
    dynamic var completed : Bool = false
    let mission = LinkingObjects(fromType: Mission.self, property: "tasks")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
