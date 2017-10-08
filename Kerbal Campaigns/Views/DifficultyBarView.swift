//
//  DifficultyBarView.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 08/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit
import SnapKit

class DifficultyBarView: UIView {
    
    var barView : UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        build()
    }
    
    private func build() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        backgroundColor = UIColor.white
        
        barView = UIView()
        addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalTo( 0 )
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func set(difficulty : Int) {
        let newWidth = frame.width / CGFloat(Constants.Campaign.MAX_DIFFICULTY) * CGFloat( difficulty )
        
        barView.backgroundColor = getColor(of : difficulty)
        
        barView.snp.updateConstraints { (make) in
            make.width.equalTo( newWidth )
        }
    }
    
    private func getColor(of difficulty : Int) -> UIColor {
        // TODO add other colors later
        switch difficulty {
        case 1:
            return Colors.level_1
        case 2:
            return Colors.level_2
        default:
            return Colors.level_3
        }
    }

}
