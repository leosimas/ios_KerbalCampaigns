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
        
        self.tabBarItem.image = nil
        
        labelTitle.text = mission.name
        updateCompletedObjectives()
        buildTasks()
    }
    
    private func buildTasks() {
        let methods = Kitten.vertical().from(scrollView)
        
        let padding = 16
        let paddingVertical = padding / 2
        let paddingStart = padding * 3
        
        
        
        for (index, task) in mission.tasks.enumerated() {
            let checkboxView = CheckboxView()
            checkboxView.bind(on: task.completed, text: task.name, handler: { (on) in
                KerbalManager.shared.mark(task : task, completed : on)
                self.updateCompletedObjectives()
            })
            
            if index == 0 {
                checkboxView.label.snp.updateConstraints({ (make) in
                    make.top.equalToSuperview().offset(16)
                })
            }
            
            methods.add(checkboxView)
                .sidePadding(padding)
            
            for subtask in task.subTasks {
                let label = UILabel()
                label.text = subtask.name
                label.numberOfLines = 0
                label.font = UIFont.systemFont(ofSize: Dimensions.fontSmall)
                
                let view = UIView()
                view.addSubview(label)
                label.snp.makeConstraints({ (make) in
                    make.top.equalToSuperview().offset(paddingVertical)
                    make.bottom.equalToSuperview().inset(paddingVertical)
                    make.width.equalToSuperview()
                    make.centerX.equalToSuperview()
                })
                
                methods.add(view)
                    .sideStartPadding(paddingStart)
                    .sideEndPadding(padding)
            }
            
            if index < (mission.tasks.count - 1) {
                let dividerArea = UIView()
                
                let divider = UIView()
                dividerArea.addSubview(divider)
                divider.snp.makeConstraints({ (make) in
                    make.height.equalTo(1)
                    make.top.equalToSuperview().offset(8)
                    make.bottom.equalToSuperview().inset(16)
                    make.width.equalTo(200)
                    make.centerX.equalToSuperview()
                })
                divider.backgroundColor = UIColor.lightGray
                
                methods.add(dividerArea)
                    .sidePadding(paddingStart)
            }
            
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
