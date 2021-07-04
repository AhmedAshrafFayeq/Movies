//
//  LoginViewController.swift
//  MovieApp
//
//  Created by Ahmed Fayek on 7/3/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func loginBtnAction(_ sender: Any) {
        let userName = userNameTF.text
        let password = passwordTF.text
        
        let isAVerifiedUser = verifyUser(userName: userName, password: password)
        if isAVerifiedUser {
            goToHomeScreen()
            print("donnneee")
        }else{
            print("not valid user")
        }
    }
    
    func verifyUser(userName: String?, password: String?)-> Bool{
        if userName == "ahmed" && password == "123456"{
            return true
        }
        return false
    }
    
    func goToHomeScreen(){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(true, forKey: "loginState")
        
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "homeVC") as! HomeViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
        
        //self.window?.rootViewController = homeVC
        
//        let homeVC = self.storyboard?.instantiateViewController(identifier: "homeVC") as! HomeViewController
//        self.navigationController?.pushViewController(homeVC, animated: true)
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = homeVC
        
    }
    
}
