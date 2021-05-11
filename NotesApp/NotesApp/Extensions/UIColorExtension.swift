//
//  UIColorExtension.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/8/21.
//

import Foundation
import UIKit

extension UIColor {
    
    struct NoteColor {
        static var yellow = UIColor(red: 255/255, green: 244/255, blue: 117/255, alpha: 1.0)
        static var cyan = UIColor(red: 167/255, green: 244/255, blue: 235/255, alpha: 1.0)
        static var red = UIColor(red: 225/255, green: 130/255, blue: 121/255, alpha: 1.0)
        static var green = UIColor(red: 204/255, green: 255/255, blue: 144/255, alpha: 1.0)
        static var lightPurple = UIColor(red: 232/255, green: 234/255, blue: 237/255, alpha: 1.0)
        static var purple = UIColor(red: 215/255, green: 174/255, blue: 251/255, alpha: 1.0)
        static var orange = UIColor(red: 251/255, green: 188/255, blue: 4/255, alpha: 1.0)
        static var pink = UIColor(red: 253/255, green: 207/255, blue: 232/255, alpha: 1.0)
        static var blue = UIColor(red: 203/255, green: 240/255, blue: 248/255, alpha: 1.0)
    }
    
    // Extracted from hackingwithswift.com
    public convenience init?(hex: String) {
            let r, g, b, a: CGFloat

            if hex.hasPrefix("#") {
                let start = hex.index(hex.startIndex, offsetBy: 1)
                let hexColor = String(hex[start...])

                if hexColor.count == 6 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                        b = CGFloat((hexNumber & 0x0000ff)) / 255
                                    
                                    a = CGFloat(1.0)

                        self.init(red: r, green: g, blue: b, alpha: a)
                        return
                    }
                }
            }

            return nil
        }
    
    // Extracted from cocoacasts.com
    var toHex: String? {
        return toHex()
    }
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return "#\(String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255)))"
        } else {
            return "#\(String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)))"
        }
    }
}
