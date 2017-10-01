//
//  CampaignCell.swift
//  Kerbal Campaigns
//
//  Created by SSA on 14/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit

class CampaignCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelLevel: UILabel!
    
    func setup(campaign : Campaign) {
        labelTitle.text = campaign.name
        labelTime.text = campaign.length
        labelLevel.text = campaign.difficulty
    }

}
