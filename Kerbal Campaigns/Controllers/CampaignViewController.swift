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
    
    override func viewDidLoad() {
        buttonMissions.setTitle("Missions \(campaign.missions.count)", for: .normal)
        textIntro.text = campaign.introduction
        textIntro.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    @IBAction func onMissionsButtonTap(_ sender: Any) {
        
        let missionsVC = storyboard?.instantiateViewController(withIdentifier: "MissionsViewController") as! MissionsViewController
        missionsVC.campaign = campaign
        navigationController?.pushViewController(missionsVC, animated: true)
        
    }
}
