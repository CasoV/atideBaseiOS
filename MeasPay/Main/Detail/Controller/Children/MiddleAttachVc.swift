//
//  MiddleAttachVc.swift
//  ycxm
//
//  Created by 高小伟 on 2020/7/20.
//  Copyright © 2020 末末班车. All rights reserved.
//

import UIKit
import WebKit

class MiddleAttachVc: UIViewController {
    var filePath:String!
    var web: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let staHeight:CGFloat = UIDevice().isX() ? 20 : 0
         web = WKWebView.init(frame:CGRect(x: 0, y: 0, width: screen_w, height: screen_h - 80))
        self.view .addSubview(web)
        
        // Do any additional setup after loading the view.
        web.isMultipleTouchEnabled = true
        web.load(URLRequest.init(url: URL(fileURLWithPath:filePath ?? "")))
    }
    func reload(){
        if(web == nil){
            return
        }
         web.load(URLRequest.init(url: URL(fileURLWithPath:filePath ?? "")))
    }

}
