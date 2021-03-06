//
//  Colors.swift
//  Kerbal Campaigns
//
//  Created by SoSucesso on 08/10/17.
//  Copyright © 2017 Simas Team. All rights reserved.
//

import UIKit

struct Colors {
    
    static let primary = Colors.hexStringToUIColor(hex: "283593")
    static let secondary = Colors.hexStringToUIColor(hex: "3f51b5")
    static let progressBar = Colors.hexStringToUIColor(hex: "33ff00")
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
