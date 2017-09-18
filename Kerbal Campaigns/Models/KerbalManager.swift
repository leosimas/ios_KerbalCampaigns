//
//  KerbalManager.swift
//  Kerbal Campaigns
//
//  Created by SSA on 15/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import RealmSwift

class KerbalManager {
    
    static let shared = KerbalManager()
    
    private let realm = try! Realm()
    
    private init() { }
    
    func testLoading() {
        let campaigns = realm.objects(Campaign.self)
        if campaigns.count > 0 {
            return
        }
        
        
        let t1 = Task(value: ["t1"])
        let t2 = Task(value: ["t2"])
        let t3 = Task(value: ["t3"])
        
        let m1 = Mission(value: ["m1"])
        m1.tasks.append(t1)
        m1.tasks.append(t2)
        
        let m2 = Mission(value: ["m2"])
        m2.tasks.append(t3)
        
        let c1 = Campaign(value: ["c1"])
        c1.missions.append(m1)
        
        let c2 = Campaign(value: ["c2"])
        
        try! realm.write {
            realm.add(c1)
            realm.add(c2)
        }
    }
    
}
