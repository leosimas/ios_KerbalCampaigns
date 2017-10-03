//
//  MissionsViewController.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 02/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit

class MissionsViewController : UITabBarController {
    
    var campaign : Campaign!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tabs : [UIViewController] = []
        for (index, mission) in campaign.missions.enumerated() {
            let tasksVC = storyboard?.instantiateViewController(withIdentifier: "TasksViewController") as! TasksViewController
            tasksVC.mission = mission
            tasksVC.title = "Mission \(index+1)"
            tabs.append( tasksVC )
        }
        
        viewControllers = tabs
        selectedIndex = 0
    }
    
}
