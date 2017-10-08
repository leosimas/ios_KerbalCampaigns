//
//  CampaignViewController.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 01/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit

class CampaignViewController : UIViewController {
    
    var campaign : Campaign!
    
    @IBOutlet weak var buttonMissions: UIButton!
    @IBOutlet weak var textIntro: UITextView!
    @IBOutlet weak var textDifficulty: UILabel!
    @IBOutlet weak var textProgress: UILabel!
    @IBOutlet weak var textTime: UILabel!
    
    private var viewInitialized = false
    
    override func viewDidLoad() {
        textIntro.text = campaign.introduction
        textDifficulty.text = campaign.difficultyText
        textTime.text = campaign.length
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCampaignStatus()
        if !viewInitialized {
            textIntro.scrollRectToVisible(CGRect(origin: .zero, size: .zero), animated: false)
            viewInitialized = true
        }
    }
    
    private func updateCampaignStatus() {
        var completed = 0
        for mission in campaign.missions {
            if (mission.completed) {
                completed += 1
            }
        }
        
        let total = campaign.missions.count
        buttonMissions.setTitle("Missions \(completed)/\(total)", for: .normal)
        
        let progress = Int(Float(completed) / Float(total) * 100)
        textProgress.text = "\(progress)% completed"
    }
    
    @IBAction func onMissionsButtonTap(_ sender: Any) {
        let missionsVC = storyboard?.instantiateViewController(withIdentifier: "MissionsViewController") as! MissionsViewController
        missionsVC.campaign = campaign
        navigationController?.pushViewController(missionsVC, animated: true)
    }
}
