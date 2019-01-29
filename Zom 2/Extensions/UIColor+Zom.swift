//
//  UIColor+Zom.swift
//  Zom 2
//
//  Created by N-Pex on 29.01.19.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 1
        
        var hex: UInt32 = 0
        if scanner.scanHexInt32(&hex) {
            self.init(netHex: UInt(hex))
        }
        else {
            self.init(netHex: 0xFFFFFFFF)
        }
    }
    
    convenience init(a: UInt, red: UInt, green: UInt, blue: UInt) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    convenience init(netHex:UInt) {
        self.init(a: (netHex >> 24) & 0xff, red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    func hexString() -> String {
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0
        var a: Float = 0
        
        if let components = cgColor.components {
            r = Float(components[0])
            g = Float(components[1])
            b = Float(components[2])
            a = Float(components[3])
        }
        
        return String(format: "#%02lX%02lX%02lX%02lX",
                      lroundf(a * 255),
                      lroundf(r * 255),
                      lroundf(g * 255),
                      lroundf(b * 255))
    }
    
    func asImage() -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(cgColor)
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
