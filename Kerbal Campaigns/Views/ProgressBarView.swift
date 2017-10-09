//
//  ProgressBarView.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 08/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit
import SnapKit

class ProgressBarView: UIView {
    
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
        barView.backgroundColor = Colors.progressBar
        addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalTo( 0 )
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func set(progress : Int) {
        var newWidth : CGFloat
        if progress == 0 {
            newWidth = 0
        } else {
            newWidth = frame.width * CGFloat(progress) / 100
        }
        
        barView.snp.updateConstraints { (make) in
            make.width.equalTo( newWidth )
        }
    }

}
