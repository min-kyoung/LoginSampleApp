//
//  MainViewController.swift
//  LoginSampleApp
//
//  Created by 노민경 on 2021/12/20.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    @IBOutlet weak var lblWelcome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // popGesture 비활성화 (뒤로가기 등 방지)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        // firebaseAuth로 로그인한 사용자를 가져옴 (없다면 "고객"으로 표시)
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        lblWelcome.text = """
            환영합니다.
            \(email)님
            """
    }
    
    // 로그아웃 버튼 클릭
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do { // 에러가 발생하지 않을 경우
            try firebaseAuth.signOut()
            // 버튼을 눌렀을 때 첫번째 화면으로 넘어감
            self.navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError { // 에러가 발생하는 경우
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
}
