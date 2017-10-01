//
//  MainViewController.swift
//  Kerbal Campaigns
//
//  Created by SSA on 14/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        KerbalManager.shared.loadCampaigns { (errorMessage, campaigns) in
            guard let list = campaigns else {
                print(errorMessage ?? "error")
                return
            }
            
            print("campaigns count = \(list.count)")
        }
        
    }

}
