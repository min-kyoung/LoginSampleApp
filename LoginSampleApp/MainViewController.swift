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
    @IBOutlet weak var btnPasswordReset: UIButton!
    
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
        
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password" // 이메일/비밀번호로 로그인 함
        // 이메일/비밀번호로 로그인하지 않을 경우 '비밀번호 변경' 버튼 숨김
        btnPasswordReset.isHidden = !isEmailSignIn
        
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
    
    // 비밀번호 변경 버튼 클릭
    @IBAction func btnPasswordReset(_ sender: UIButton) {
        // 현재 사용자가 가지고 있는 이메일로 비밀번호를 초기화 할 수 있는 메일을 발송
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
    @IBAction func btnProfileUpdate(_ sender: UIButton) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "스위프트"
        changeRequest?.commitChanges { _ in
            let displayName = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "고객"
            
            self.lblWelcome.text == """
                환영합니다.
                \(displayName)님
                """
            
        }
    }
}
