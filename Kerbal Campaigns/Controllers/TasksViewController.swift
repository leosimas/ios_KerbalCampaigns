//
//  TasksViewController.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 02/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit
import SnapKitten
import BEMCheckBox

class TasksViewController: UIViewController {
    
    var mission : Mission!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelObjectives: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = mission.name
        updateCompletedObjectives()
        buildTasks()
    }
    
    private func buildTasks() {
        let methods = Kitten.vertical().from(scrollView)
        
        for task in mission.tasks {
            let checkboxView = CheckboxView()
            checkboxView.bind(on: task.completed, text: task.name, handler: { (on) in
                KerbalManager.shared.mark(task : task, completed : on)
                self.updateCompletedObjectives()
            })
            
            methods.add(checkboxView)
                .sidePadding(16)
        }
        
        methods.build()
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
