//
//  LoginVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/19.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import ESTabBarController_swift

class LoginVc: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
    @IBOutlet weak var secureBtn: UIButton!
    @IBOutlet weak var pwdEmptyBtn: UIButton!
    @IBOutlet weak var nameEmptyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initUI()
        
    }
    func initUI(){
        secureBtn.setImage(UIImage(named: "pass_visuable"), for: .selected)
        nameTF.text = UserDefaults.standard.string(forKey: "user")
        pwdTF.text = UserDefaults.standard.string(forKey: "pwd")
        self.setFields(textField: nameTF, text: nameTF.text! as NSString)
        self.setFields(textField: pwdTF, text: pwdTF.text! as NSString)
    }
    
    //MARK: - 按钮事件
    @IBAction func login(_ sender: Any) {
        if nameTF.text?.count == 0 || pwdTF.text?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入用户名或密码")
            return
        }
        NetWorkRequest(.login(Dict:["user":nameTF.text!,"pwd":pwdTF.text!])) { (response) -> (Void) in
            //登录成功
            UserDefaults.standard.set(self.nameTF.text!, forKey:"user")
            UserDefaults.standard.set(self.pwdTF.text!, forKey:"pwd")
            let json = JSON(parseJSON:response)
            
            UserDefaults.standard.set(json["data"]["id"].stringValue, forKey: "id")
            UserDefaults.standard.set(json["data"]["orgName"].stringValue, forKey: "orgName")
            UserDefaults.standard.set(json["data"]["name"].stringValue, forKey: "name")
            
           self.showHome()
        }
    }
    func showHome() {

        let tabBarController = ESTabBarController()
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let s1 = UIStoryboard(name: "Home", bundle: nil)
        let v1 = s1.instantiateViewController(withIdentifier: "HomeVc")as! HomeVc
        let s2 = UIStoryboard(name: "WorkBench", bundle: nil)
        let v2 = s2.instantiateViewController(withIdentifier: "WorkBenchVc")as! WorkBenchVc
        let s3 = UIStoryboard(name: "Mine", bundle: nil)
        let v3 = s3.instantiateViewController(withIdentifier: "MineVc")as! MineVc
        
        v1.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "ic_home"), selectedImage: UIImage(named: "ic_home_fill"))
        v2.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "ic_message"), selectedImage: UIImage(named: "ic_message_fill"))
        v3.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(), title: nil, image: UIImage(named: "ic_my"), selectedImage: UIImage(named: "ic_my_fill"))
        
        tabBarController.viewControllers = [v1, v2, v3]
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.backgroundImage = UIImage.init()
        tabBarController.tabBar.shadowImage = UIImage.init()
        let navigationController = BaseNavVc.init(rootViewController: tabBarController)
         navigationController.isNavigationBarHidden = true
        self.present(navigationController, animated: true, completion: nil)
    }
    @IBAction func nameEmpty(_ sender: Any) {
        nameTF.text = nil
        nameEmptyBtn.isHidden = true
    }
    @IBAction func pwdEmpty(_ sender: Any) {
        pwdTF.text = nil
        pwdEmptyBtn.isHidden = true
    }
    @IBAction func secure(_ sender: Any) {
        pwdTF.isSecureTextEntry = !pwdTF.isSecureTextEntry
        secureBtn.isSelected = !secureBtn.isSelected
    }
    
    //MARK: - 代理方法
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        self.setFields(textField: textField, text: newText as NSString)
        return true
    }
    
    
    /// 设置默认值
    ///
    /// - Parameters:
    ///   - textField: 判定控件
    ///   - text: 判定值
    func setFields(textField:UITextField, text:NSString) {
        if(textField == nameTF && text.length == 0){
            nameEmptyBtn.isHidden = true
        }else if(textField == pwdTF && text.length == 0){
            pwdEmptyBtn.isHidden = true
        }else{
            pwdEmptyBtn.isHidden = false
            nameEmptyBtn.isHidden = false
        }
    }
}
