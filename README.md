# LoginSampleApp
## Description
Firebase Authentication를 이용하여 로그인 기능을 구현하는 프로젝트이다.
이메일/비밀번호를 통한 로그인, 구글 계정을 이용한 로그인, 애플 계정을 이용한 로그인을 구현한다.
## Prerequisite
* Firebase를 이용하기 위해 프로젝트 추가를 한다.
  1. https://firebase.google.com 에서 새 프로젝트를 생성한다.
  2. 콘솔 앱 프로젝트가 추가되었다면 ios 앱 추가를 선택한다. <br>
     이 때, iOS의 번들 ID에는 Xcode 프로젝트 파일의 Bundle Identifier를 입력한다.
  3. GoogleService-info.plist를 다운받아 Xcode 프로젝트 파일에 추가한다.
* Firebase SDK를 CocoaPods를 이용하여 설치한다.
  1. 터미널에서 해당 프로젝트 경로로 이동한 후 **pod init**을 입력하여 Podfile을 생성한다.
      <img src="https://user-images.githubusercontent.com/62936197/149737343-f41e8605-103f-41be-b461-55245e5ff0a1.png" width="300" height="150">
  
  2. Podfile을 열어서 ** # Pods for LoginSampleApp** 아래에 두 가지를 추가한 후 저장한다.
      ```swift
       pod 'Firebase/Auth'
       pod 'GoogleSignIn'
      ```
  3. 터미널로 돌아와 **pod install**을 입력하여 SDK를 설치한다.
      <img src="https://user-images.githubusercontent.com/62936197/149737760-0988b7c6-bdc9-46c2-9787-a0f2b2f6e001.png" width="550" height="160">
  
  4. pod을 추가한 후에는 xcworkspace 파일을 이용해서 개발을 진행한다.
  5. AppDelegate.swift에서 
## Files
>LoginViewController.swift
*
>EnterEmailViewController.swift
*
>MainViewController.swift
*
