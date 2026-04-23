//
//  Helper.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/20.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit

let screen_h = UIScreen.main.bounds.size.height
let screen_w = UIScreen.main.bounds.size.width
let status_bar_h = UIApplication.shared.statusBarFrame.size.height
let nav_bar_h:CGFloat = 44

func armColor()->UIColor{
    let red = CGFloat(arc4random()%256)/255.0
    let green = CGFloat(arc4random()%256)/255.0
    let blue = CGFloat(arc4random()%256)/255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

    
