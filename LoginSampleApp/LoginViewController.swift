//
//  LoginViewController.swift
//  LoginSampleApp
//
//  Created by 노민경 on 2021/12/13.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    @IBOutlet weak var btnEmailLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: GIDSignInButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [btnEmailLogin, btnGoogleLogin, btnAppleLogin].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigation bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
        // Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    // 구글로 로그인하기 버튼 클릭
    @IBAction func btnGoogleLoginTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // 애플로 로그인하기 버튼 클릭
    @IBAction func btnAppleLoginTapped(_ sender: UIButton) {
        // Firebase 인증
    }
    
    
}
