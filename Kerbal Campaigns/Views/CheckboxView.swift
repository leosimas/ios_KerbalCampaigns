//
//  CheckboxView.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 04/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit
import BEMCheckBox
import SnapKit

class CheckboxView : UIView {
    
    var bemCheck : BEMCheckBox!
    var label : UILabel!
    var changeHandler : ((Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
        
        bemCheck.delegate = self
        
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLabelTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func build() {
        bemCheck = BEMCheckBox()
        addSubview(bemCheck)
        bemCheck.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(16)
        }
        
        label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Dimensions.fontMedium)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(bemCheck.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func bind(on : Bool, text : String, handler : @escaping ((Bool)->Void)) {
        bemCheck.on = on
        label.text = text
        changeHandler = handler
    }
    
    func onLabelTap() {
        bemCheck.setOn(!bemCheck.on, animated: true)
        changeHandler?(bemCheck.on)
    }
    
}

extension CheckboxView : BEMCheckBoxDelegate {
    
    func didTap(_ checkBox: BEMCheckBox) {
        print("didTap")
        changeHandler?(checkBox.on)
    }
    
}
