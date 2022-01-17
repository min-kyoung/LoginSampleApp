# LoginSampleApp
## Description
Firebase Authentication를 이용하여 로그인 기능을 구현하는 프로젝트이다. <br>
이메일/비밀번호를 통한 로그인, 구글 계정을 이용한 로그인, 애플 계정을 이용한 로그인을 구현한다.
## Prerequisite
* Firebase를 이용하기 위해 프로젝트 추가를 한다.
  1. https://firebase.google.com 에서 새 프로젝트를 생성한다.
  2. 콘솔 앱 프로젝트가 추가되었다면 ios 앱 추가를 선택한다. <br>
     이 때, iOS의 번들 ID에는 Xcode 프로젝트 파일의 Bundle Identifier를 입력한다.
  3. GoogleService-info.plist를 다운받아 Xcode 프로젝트 파일에 추가한다.
* Firebase Authentication 탭에서 세 가지 로그인 방식을 활성화 한다.<br>
  <img src="https://user-images.githubusercontent.com/62936197/149752867-a86f49b8-ef46-4697-82b2-1c02975f4ebf.png" width="550" height="200">
* Firebase SDK를 CocoaPods를 이용하여 설치한다.
  1. 터미널에서 해당 프로젝트 경로로 이동한 후 **pod init**을 입력하여 Podfile을 생성한다.<br>
      <img src="https://user-images.githubusercontent.com/62936197/149737343-f41e8605-103f-41be-b461-55245e5ff0a1.png" width="250" height="150"> 
  2. Podfile을 열어서 **# Pods for LoginSampleApp** 아래에 두 가지를 추가한 후 저장한다.
      ```swift
       pod 'Firebase/Auth'
       pod 'GoogleSignIn'
      ```
     
  3. 터미널로 돌아와 **pod install**을 입력하여 SDK를 설치한다.
      <img src="https://user-images.githubusercontent.com/62936197/149737760-0988b7c6-bdc9-46c2-9787-a0f2b2f6e001.png" width="550" height="160">
  4. pod을 추가한 후에는 xcworkspace 파일을 이용해서 개발을 진행한다.
 * 구글 계정 로그인을 사용하기 위해서 맞춤 URL 스키마를 구성한다.
    1. XCode 프로젝트에서 **TARGETS > Info**를 선택한 후 URL Types를 추가한다.
    2. URL Scheme에 GoogleService-info.plist의 REVERSED_CLIENT_ID를 입력한다.<br>
        <img src="https://user-images.githubusercontent.com/62936197/149761145-efaa99ba-5e04-4ba8-a794-b9ff5ff8eca5.png" width="550" height="160">
      
 * 애플 계정 로그인을 사용하기 위해서는 Apple Developer 가입을 전제로 한다.
    1. XCode 프로젝트에서 **TARGETS > Signing & Capabilities**를 선택한 후 Capability 추가에서 **Sign in with Apple**을 선택한다. <br>
        <img src="https://user-images.githubusercontent.com/62936197/149766542-90ad0aa7-06cc-40e0-b464-a44175219ace.png" width="400" height="200"> <br>
    2. **https://developer.apple.com > Account > Overview > Certificates, Identifiers & Profiles**항목으로 들어간 후 Identifier 탭에서 **Service IDs**를 추가한다. <br>
        <img src="https://user-images.githubusercontent.com/62936197/149766598-f4d6b544-f7fa-4dc5-8ab3-919a0dd64498.png" width="550" height="160">
    3. 추가된 Identifier를 다시 클릭하여 **Sign in with Apple**의 ENABLED를 체크한 후 configure를 클릭한다.
    4. **Domain and Subdomains**에는 firebase에서 제공해주는 승인된 도메인을 입력하고, **Return URLs**에는 firebase에서 Apple 로그인 방식을 추가할 때 제공해주었던 콜백 URL을 입력한다.<br>
        <img src="https://user-images.githubusercontent.com/62936197/149766756-acb1c8da-1a0e-446d-84ba-0e7771892a24.png" width="300" height="160">
        <img src="https://user-images.githubusercontent.com/62936197/149766771-35260b36-5ab1-4dbe-ac40-95616a068225.png" width="450" height="160"> <br>
        <img src="https://user-images.githubusercontent.com/62936197/149766790-5e332690-f466-4107-9213-ff496a8fbf51.png" width="550" height="160">
## Files
>AppDelegate.swift
* AppDelegate.swift에서 Firebase 추가 및 초기화 코드를 작성한다. 
  ```swift
   import UIKit
   import Firebase
   import GoogleSignIn

   @main
     class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Firebase 초기화
            FirebaseApp.configure()

            // 구글 로그인 초기화
            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
            GIDSignIn.sharedInstance().delegate = self

            return true
        }
            
        // 구글의 인증 프로세스가 끝날 때 앱이 수신하는 url을 처리하는 역할
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
             return GIDSignIn.sharedInstance().handle(url)
        }
           
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
                print("ERROR Google Sign IN \(error.localizedDescription)")
                return
            }

            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { _, _ in
                self.showMainViewController()
            }
        }
        // 등록 후 메인화면으로 진입하기 위해
        private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
        }
     }
    ```
>LoginViewController.swift
* 어플을 실행하면 가장 먼저 보여질 메인 화면
  * 구글 계정으로 로그인을 시도하는 경우 
    ```swift
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
    ```
  * 애플 계정으로 로그인을 시도하는 경우
    ```swift
    extension LoginViewController {
        func startSignInWithAppleFlow() {
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest() // requset에 nonce가 포함되어서 릴레이 공격을 방지하고 firebase에서도 무결성 확인을 할 수 있게 됨
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }

        private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                return String(format: "%02x", $0)
            }.joined()

            return hashString
        }

        // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
        private func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            let charset: Array<Character> =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length

            while remainingLength > 0 {
                let randoms: [UInt8] = (0 ..< 16).map { _ in
                    var random: UInt8 = 0
                    let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                    if errorCode != errSecSuccess {
                        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                    }
                    return random
              }
            
                randoms.forEach { random in
                    if remainingLength == 0 {
                        return
                    }

                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }

            return result
        }
    }
    ```
>EnterEmailViewController.swift
* 메인화면에서 이메일/비밀번호로 계속하기 버튼을 클릭할 때 넘어갈 화면 
  * 신규 사용자의 경우, 이메일 주소와 비밀번호를 작성한 후 다음 버튼을 누르면 사용자의 정보를 firebase auth에 저장한다.
    ```swift
      @IBAction func btnNextTapped(_ sender: UIButton) {
          let email = tfEmail.text ?? ""
          let password = tfPassword.text ?? ""

          // 신규 사용자 생성
          Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
              guard let self = self else { return }

              // 에러가 발생할 경우
              if let error = error {
                  let code = (error as NSError).code
                  switch code {
                  case 17007: // 이미 가입한 계정일 경우
                      self.loginUser(withEmail: email, password: password) // 로그인하기
                  default:
                      self.lblErrorMessage.text = error.localizedDescription
                  }
              }else { // 에러가 없이 로그인이 성공적으로 끝났을 경우
                  self.showMainViewController()  // 컨트롤러를 넘겨줌
              }
          }
      }
    ```
>MainViewController.swift
* 모든 로그인이 성공적으로 이루어졌을 때 넘어갈 화면
  ```swift
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
          btnPasswordReset.isHidden = !isEmailSignIn // 이메일/비밀번호로 로그인하지 않을 경우 '비밀번호 변경' 버튼 숨김
      }
  ```
