//
//  EnterEmailViewController.swift
//  LoginSampleApp
//
//  Created by 노민경 on 2021/12/20.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.layer.cornerRadius = 30
        
        // 값 입력 전에는 '다음' 버튼 비활성화
        btnNext.isEnabled = false
        
        tfEmail.delegate = self
        tfPassword.delegate = self
        
        // 입력하기 쉽도록 자동적으로 커서를 위치하게 함
        tfEmail.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation ber 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    // 다음 버튼 클릭
    @IBAction func btnNextTapped(_ sender: UIButton) {
        // Firebase 이메일/비밀번호 인증
        let email = tfEmail.text ?? ""
        let password = tfPassword.text ?? ""
        
        // 신규 사용자 생성
            // 순환 참조 방지를 위한 weak self
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            // 에러가 발생할 경우
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 경우
                    // 로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.lblErrorMessage.text = error.localizedDescription
                }
            }else { // 에러가 없이 로그인이 성공적으로 끝났을 경우
                // 컨트롤러를 넘겨줌
                self.showMainViewController()
            }
            
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    private func loginUser(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] _, error in
            guard let self = self else { return }
            
            if let error = error { // 로그인 하는 과정에서 에러 발생
                self.lblErrorMessage.text = error.localizedDescription
            }else {
                self.showMainViewController()
            }
        }
    }
}

extension EnterEmailViewController: UITextFieldDelegate{
    // editing이 끝나면 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // 이메일과 비밀번호에 입력한 값을 확인해서 '다음' 버튼을 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 이메일과 비밀번호를 둘 다 입력했을 때 활성화
        let isEmailEmpty = tfEmail.text == ""
        let isPasswordEmpty = tfPassword.text == ""
        
        btnNext.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
    
}
