//
//  Theme.swift
//  Photo Vault
//
//  Created by Josh Andrews on 2/3/19.
//  Copyright © 2019 Josh Andrews. All rights reserved.
//

import UIKit.UIFont

class Theme {
    
    class fonts {
        class func avenirLight(size: CGFloat) -> UIFont{
            return UIFont(name: "Avenir-Light", size: size)!
        }
        class func avenirBlack(size: CGFloat) -> UIFont{
            return UIFont(name: "Avenir-Black", size: size)!
        }
        class func avenirMedium(size: CGFloat) -> UIFont{
            return UIFont(name: "Avenir-Medium", size: size)!
        }
        class func futuraMedium(size: CGFloat) -> UIFont{
            return UIFont(name: "Futura-Medium", size: size)!
        }
    }
    
    class inset {
        static var single = 8
        static var double = 16
        static var triple = 24
    }
}
    

