//
//  KerbalManager.swift
//  Kerbal Campaigns
//
//  Created by SSA on 15/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import RealmSwift
import FirebaseDatabase
import SwiftyUserDefaults
import SystemConfiguration

class KerbalManager {
    
    static let shared = KerbalManager()
    
    private let realm : Realm!
    private var databaseRef : DatabaseReference!
    
    private static let TIMEOUT = 30
    
    private init() {
        realm = try! Realm()
        databaseRef = Database.database().reference()
    }
    
    private func loadCampaigns() -> [Campaign] {
        let campaigns = self.realm!.objects(Campaign.self)
        return Array(campaigns)
    }
    
    private func isInternetAvailable() -> Bool {
        // https://stackoverflow.com/a/40148883
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func loadCampaigns(completion : @escaping ((String?, [Campaign]?)-> Void)) {
        var cancelUpdate = true
        
        if !isInternetAvailable() {
            self.cancelRequest(completion: completion)
            return
        }
        
        let reference = databaseRef.child("lastUpdate")
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            cancelUpdate = false
            
            let serverUpdate = snapshot.value as! Int
            
            let lastUpdate = Defaults[.lastUpdate]
            if lastUpdate != serverUpdate {
                self.syncCampaigns(lastUpdate :serverUpdate, completion: completion)
            } else {
                completion(nil, self.loadCampaigns())
            }
        })
        
        let deadlineTime = DispatchTime.now() + .seconds(KerbalManager.TIMEOUT)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if cancelUpdate {
                reference.removeAllObservers()
                self.cancelRequest(completion: completion)
            }
        }
    }
    
    private func cancelRequest(completion : ((String?, [Campaign]?)-> Void)) {
        let campaigns = self.loadCampaigns()
        if campaigns.count == 0 {
            completion("Unable to load the campaigns. Try again later.", nil)
        } else {
            completion(nil, campaigns)
        }
    }
    
    func syncCampaigns(lastUpdate : Int, completion : @escaping ((String?, [Campaign]?)-> Void)) {
        var cancelUpdate = true
        
        if !isInternetAvailable() {
            self.cancelRequest(completion: completion)
            return
        }
        
        let reference = databaseRef.child("campaigns")
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            cancelUpdate = false
            
            var campaignsList : [Campaign] = []
            
            let campaignsArray = snapshot.value as! NSArray
            for campaignAny in campaignsArray {
                let jsonCampaign = campaignAny as! NSDictionary
                let campaign : Campaign = self.createCampaign(jsonCampaign)
                
                campaignsList.append(campaign)
            }
            
            Defaults[.lastUpdate] = lastUpdate
            
            completion(nil, campaignsList)
            
        })
        
        let deadlineTime = DispatchTime.now() + .seconds(KerbalManager.TIMEOUT)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if cancelUpdate {
                reference.removeAllObservers()
                self.cancelRequest(completion: completion)
            }
        }
    }
    
    private func createCampaign(_ jsonCampaign : NSDictionary) -> Campaign {
        var campaign : Campaign!
        
        let id = jsonCampaign[Constants.ResponseKeys.ID] as! String
        let localCampaigns = realm.objects(Campaign.self).filter( NSPredicate(format: "id = %@", id) )
        
        if ( localCampaigns.count != 0 ) {
            // old campaigns are not changed
            return localCampaigns.first!
        }
        
        // add new campaigns
        campaign = Campaign(value: [id])
        campaign.difficulty = jsonCampaign[Constants.ResponseKeys.DIFFICULTY] as! String
        campaign.introduction = jsonCampaign[Constants.ResponseKeys.INTRO] as! String
        campaign.length = jsonCampaign[Constants.ResponseKeys.LENGTH] as! String
        campaign.name = jsonCampaign[Constants.ResponseKeys.NAME] as! String
        // extract difficulty text and number:
        // pattern : N/10 (TEXT)
        let str = campaign.difficulty
        
        var indexFirst = str.range(of: "(")!.upperBound
        let indexLast = str.range(of: ")")!.lowerBound
        campaign.difficultyText = str.substring(with: Range(uncheckedBounds: (lower: indexFirst, upper: indexLast)))
        
        indexFirst = str.range(of: "/")!.lowerBound
        let value = str.substring(to: indexFirst).trimmingCharacters(in: .whitespacesAndNewlines)
        campaign.difficultyNumber = Int(value)!
        
        let missionsArray = jsonCampaign[Constants.ResponseKeys.MISSIONS] as! NSArray
        campaign.missions.append(objectsIn: createMissions(missionsArray))
        
        try! realm.write {
            realm.add(campaign)
        }
        
        return campaign
    }
    
    private func createMissions(_ missionsArray : NSArray) -> [Mission] {
        var missions : [Mission] = []
        
        for missionAny in missionsArray {
            let jsonMission = missionAny as! NSDictionary
            let mission = Mission()
            mission.id = jsonMission[Constants.ResponseKeys.ID] as! String
            mission.name = jsonMission[Constants.ResponseKeys.NAME] as! String
            
            let tasksArray = jsonMission[Constants.ResponseKeys.TASKS] as! NSArray
            mission.tasks.append(objectsIn: createTasks(tasksArray))
            
            missions.append(mission)
        }
        
        return missions
    }
    
    private func createTasks(_ tasksArray : NSArray) -> [Task] {
        var tasks : [Task] = []
        
        for taskAny in tasksArray {
            let jsonTask = taskAny as! NSDictionary
            
            let task = Task()
            task.id = jsonTask[Constants.ResponseKeys.ID] as! String
            task.name = jsonTask[Constants.ResponseKeys.NAME] as! String
            
            let stringArray = jsonTask[Constants.ResponseKeys.SUBTASKS] as! [String]
            task.subTasks.append(objectsIn: createSubTasks(stringArray))
            
            tasks.append(task)
        }
        
        return tasks
    }
    
    private func createSubTasks( _ subTasksArray : [String] ) -> [SubTask] {
        var subTasks : [SubTask] = []
        for name in subTasksArray {
            subTasks.append( SubTask(value: [ name ]) )
        }
        
        return subTasks
    }
    
    func mark(task : Task, completed : Bool) {
        try! realm.write {
            task.completed = completed
            
            var missionCompleted = true
            
            let mission = task.mission.first!
            for t in mission.tasks {
                if !t.completed {
                    missionCompleted = false
                    break
                }
            }
            
            mission.completed = missionCompleted
            
            var campaignCompleted = true
            
            let campaign = mission.campaign.first!
            for m in campaign.missions {
                if !m.completed {
                    campaignCompleted = false
                    break
                }
            }
            
            campaign.completed = campaignCompleted
        }
    }
    
}
