//
//  ReviewFileVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/14.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import WebKit

class ReviewFileVc: UIViewController {
    var filePath:String!
    var web: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let staHeight:CGFloat = UIDevice().isX() ? 20 : 0
         web = WKWebView.init(frame:CGRect(x: 0, y: 80 + staHeight, width: screen_w, height: screen_h - 80))
        self.view .addSubview(web)
        
        // Do any additional setup after loading the view.
        web.isMultipleTouchEnabled = true
        web.load(URLRequest.init(url: URL(fileURLWithPath:filePath ?? "")))
    }
    func reload(){
         web.load(URLRequest.init(url: URL(fileURLWithPath:filePath ?? "")))
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
