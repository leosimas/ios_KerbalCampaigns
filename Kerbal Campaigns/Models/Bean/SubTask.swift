//
//  SubTask.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 01/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import RealmSwift

class SubTask : Object {
    
    dynamic var name = ""
    
    let task = LinkingObjects(fromType: Task.self, property: "subTasks")
    
}
