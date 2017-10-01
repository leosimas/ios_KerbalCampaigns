//
//  Mission.swift
//  Kerbal Campaigns
//
//  Created by SSA on 15/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import RealmSwift

class Mission : Object {
    
    dynamic var id = ""
    dynamic var completed : Bool = false
    dynamic var name = ""
    let tasks = List<Task>()
    let campaign = LinkingObjects(fromType: Campaign.self, property: "missions")
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
