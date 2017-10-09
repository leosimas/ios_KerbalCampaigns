//
//  MainViewController.swift
//  Kerbal Campaigns
//
//  Created by SSA on 14/09/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var campaigns : [Campaign] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = Colors.primary
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        LoadingView.show(inView: view)

        KerbalManager.shared.loadCampaigns { (errorMessage, campaigns) in
            LoadingView.hide()
            
            guard let list = campaigns else {
                Dialogs.alert(controller: self, title: "Error", message: errorMessage!)
                return
            }
            
            self.campaigns = list
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    fileprivate func show( campaign : Campaign ) {
        let campaignVC = storyboard?.instantiateViewController(withIdentifier: "CampaignViewController") as! CampaignViewController
        campaignVC.campaign = campaign
        navigationController?.pushViewController(campaignVC, animated: true)
    }

}

extension MainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignCell") as! CampaignCell
        let campaign = campaigns[indexPath.row]
        cell.setup(campaign: campaign)
        return cell
    }
    
}

extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let campaign = campaigns[indexPath.row]
        show(campaign: campaign)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
