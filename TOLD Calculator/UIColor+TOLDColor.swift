//
//  UIColor+TOLDColor.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/16/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIColor {
    struct TOLDColor {
        static let Gold = UIColor(netHex: 0xFFCB39)
        static let Blue = UIColor(netHex: 0x034AA6)
        static let Red = UIColor(red:0.65, green:0.30, blue:0.33, alpha:1.00)
        static let Yellow = UIColor(netHex: 0xFFFD24)
        static let CalcBackground = UIColor.init(red: 0.97, green: 0.90, blue: 0.67, alpha: 1.00)
        static let Detail = UIColor(red:0.33, green:0.38, blue:0.66, alpha:1.00)
		static let ButtonBackground = UIColor(red:1.00, green:0.97, blue:0.84, alpha:1.00)
    }

}
