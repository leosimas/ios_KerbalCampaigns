//
//  TasksViewController.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 02/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    var mission : Mission!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelObjectives: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = mission.name
        updateCompletedObjectives()
    }
    
    private func updateCompletedObjectives() {
        var completed = 0
        for task in mission.tasks {
            if task.completed {
                completed += 1
            }
        }
        
        labelObjectives.text = "\(completed) / \(mission.tasks.count) objectivies completed"
    }
    
}
