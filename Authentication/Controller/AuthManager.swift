//
//  AuthManager.swift
//  CART
//
//  Created by t&a on 2022/11/18.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn           // Google
import AuthenticationServices // Apple


// MARK: 1. 共有メソッドクラス
// MARK: 2. Email
// MARK: 3. Google & Apple


final class AuthManager:ObservableObject{
    
    // MARK: - シングルトン
    static let shared = AuthManager()
    
    // MARK: - インスタンス
    let userDefaultsManager = UserDefaultsManager()
    var databaseManager = DatabaseManager.shared
    
    // MARK: - リファレンス
    let auth = Auth.auth()
    
    // MARK: - 観測プロパティ
    @Published var errMessage:String = ""
    
    // MARK: - 共有メソッド
    // MARK: (private) setErrorMessage :エラーメッセージ
    // MARK: withdrawal                :退会処理
    // MARK: resetPassWord             :パスワードリセットメール
    // MARK: logout                    :ログアウト
    
    // MARK: - Errorハンドリング
    private func setErrorMessage(_ error:Error?){
        if let error = error as NSError? {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.errMessage = "メールアドレスの形式が違います。"
                case .emailAlreadyInUse:
                    self.errMessage = "このメールアドレスはすでに使われています。"
                case .weakPassword:
                    self.errMessage = "パスワードが弱すぎます。"
                case .userNotFound, .wrongPassword:
                    self.errMessage = "メールアドレス、またはパスワードが間違っています"
                case .userDisabled:
                    self.errMessage = "このユーザーアカウントは無効化されています"
                default:
                    self.errMessage = "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
                }
            }
        }
    }
    
    // MARK: -  各プロバイダ退会処理 & Appleアカウントは直呼び出し
    func withdrawal(completion: @escaping (Bool) -> Void ) {
        if let user = auth.currentUser {
            self.databaseManager.ForcedReleaseMember() // シェア先も全て削除
            self.databaseManager.removeUser()          // ユーザーも削除
            user.delete { error in
                if error != nil {
                    //                    print("withDrawal:\(error.debugDescription)")
                    completion(false)
                } else {
                    // 退会成功
                    completion(true)
                }
            }
        }else{
            completion(false)
        }
    }
    
    // MARK: - リセットパスワード
    func resetPassWord(email:String,completion: @escaping (Bool) -> Void ) {
        auth.sendPasswordReset(withEmail: email) { error in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    // MARK: - ログアウト処理
    func logout(completion: @escaping (Bool) -> Void ) {
        do{
            try auth.signOut()
            self.errMessage = ""
            userDefaultsManager.allReset()
            self.databaseManager.initDic()
            completion(true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
}

extension AuthManager{
    
    // MARK: - Email/passwordユーザー
    // MARK: login                           :ログイン E-mail
    // MARK: createUser                      :新規登録 (1)
    // MARK: (private) editUserInfo          :新規登録 (2)　ユーザー名登録
    // MARK: (private) sendVerificationMail  :新規登録 (3)　確認メール送信
    // MARK: emailWithdrawal                 :E-mail退会 (1)
    // MARK: (private) reauthEmail           :E-mail再認証 退会 (2)
    // MARK: editUserInfoEmail               :ユーザー情報編集
    // MARK: updateEmail                     :ユーザーEmail編集
    
    // MARK: - email/passwordログイン
    func login(email:String,password:String,completion: @escaping (Bool) -> Void ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                if result?.user != nil{
                    self.userDefaultsManager.setUserId(result!.user.uid)
                    self.userDefaultsManager.setUserName(result!.user.displayName!)
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                self.setErrorMessage(error)
                completion(false)
            }
        }
    }
    
    // MARK: - 新規登録 - (1)
    func createUser(email:String,password:String,name:String,completion: @escaping (Bool) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                if let user = result?.user {
                    self.editUserInfo(user: user, name: name) { result in
                        completion(result)
                    }
                }else{
                    completion(false)
                }
            }else{
                self.setErrorMessage(error)
                completion(false)
            }
        }
    }
    
    // MARK: - 新規登録 - (2) ユーザー情報登録
    private func editUserInfo(user:User,name:String,completion: @escaping (Bool) -> Void ) {
        let request = user.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges { error in
            if error == nil{
                self.databaseManager.createUser(uid: user.uid, name: user.displayName!) // DB作成処理
                completion(true)
                // 確認メール送付
                //                self.sendVerificationMail(user: user) { result in
                //                    completion(result)
                //                }
            }else{
                completion(false)
            }
        }
    }
    // MARK: - 新規登録 - (3) 確認メール送信 [未使用]
    private func sendVerificationMail(user:User,completion: @escaping (Bool) -> Void ) {
        user.sendEmailVerification() { error in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    
    // MARK: - 退会処理
    func withdrawalEmail(pass:String,completion: @escaping (Bool) -> Void ) {
        if let user = auth.currentUser {
            reauthEmail(user: user,pass: pass) { result in
                if result {
                    // 再認証成功　→ 退会処理
                    self.withdrawal() { result in
                        if result{
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    // 再認証失敗
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - email再認証
    private func reauthEmail(user:User,pass:String,completion: @escaping (Bool) -> Void ) {
        // emailアカウント再認証
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: pass)
        user.reauthenticate(with: credential) { (result, error) in
            if error != nil {
                completion(false)
            } else {
                // 再認証成功
                completion(true)
            }
        }
    }
    
    // MARK: - ユーザー情報編集
    func editUserInfoEmail(name:String,pass:String,completion: @escaping (Bool) -> Void ) {
        if let user = auth.currentUser {
            reauthEmail(user: user, pass: pass) { result in
                if result {
                    let request = user.createProfileChangeRequest()
                    request.displayName = name
                    request.commitChanges { error in
                        if error == nil{
                            self.databaseManager.updateUsername(uid: user.uid, name: user.displayName!) // DB更新処理
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    completion(false)
                }
            }
        }else{
            completion(false)
        }
    }
    
    
    // MARK: - Email編集
    func updateEmail(email:String,pass:String,completion: @escaping (Bool) -> Void ) {
        if let user = auth.currentUser {
            reauthEmail(user: user, pass: pass) { result in
                if result {
                    Auth.auth().currentUser?.updateEmail(to: email) { error in
                        if error == nil{
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    completion(false)
                }
            }
        }else{
            completion(false)
        }
    }
    
    
}


extension AuthManager{
    
    // MARK: - Google & Apple
    // MARK: 1.loginGoogleAuth           :ログイン 　　　Google
    // MARK: 2.loginCredential           :ログイン 　　　Google1 Apple
    // MARK: 3.withdrawalGoogle          :退会 　  　　 Google
    // MARK: 4.editUserInfoGoogle        :ユーザー編集  Google
    // MARK: 5.(private) reauthGoogle    :再認証       Google3 Google4
    // MARK: 6.editUserNameApple         :ユーザー編集  Apple
    
    
    
    // MARK: - Googleログイン with クレデンシャル
    func loginGoogleAuth(completion: @escaping (Bool) -> Void ) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController = windowScene?.windows.first!.rootViewController!
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController!) { user, error in
            if error != nil {
                completion(false)
                return
            }
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            self.loginCredential(credential: credential,isApple: false) { result in
                if result {
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - ログインクレデンシャル for Google & Apple
    func loginCredential(credential: AuthCredential,isApple:Bool,completion: @escaping (Bool) -> Void ) {
        auth.signIn(with: credential) { result, error in
            
            if result?.user != nil{
                var userName:String = ""
                if result!.user.displayName == nil{
                    // Apple Idアカウントは初回時に名前が入らない？
                    userName = "Cart User" // デフォルトネーム
                }else{
                    userName = result!.user.displayName!
                }
                if isApple{
                    self.userDefaultsManager.setLoginProvider(2) // Appleアカウントでのログイン識別フラグ 再認証用
                }else{
                    self.userDefaultsManager.setLoginProvider(1) // Googleアカウントでのログイン識別フラグ 再認証用
                }
                self.databaseManager.createUser(uid: result!.user.uid, name: userName) // DB作成処理
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    
    // MARK: - Googleアカウント退会処理
    func withdrawalGoogle(completion: @escaping (Bool) -> Void ) {
        
        if let user = auth.currentUser {
            reauthGoogle(user: user) { result in
                if result {
                    self.withdrawal() { result in
                        if result{
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    // 再認証失敗
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - ユーザー情報編集 Google
    func editUserInfoGoogle(name:String,completion: @escaping (Bool) -> Void ) {
        if let user = auth.currentUser {
            reauthGoogle(user: user) { result in
                if result {
                    let request = user.createProfileChangeRequest()
                    request.displayName = name
                    request.commitChanges { error in
                        if error == nil{
                            self.databaseManager.updateUsername(uid: user.uid, name: user.displayName!) // DB更新処理
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    completion(false)
                }
            }
        }
    }
    
    
    // MARK: - Google再認証
    private func reauthGoogle(user:User,completion: @escaping (Bool) -> Void ) {
        
        // Googleアカウント再認証
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false)
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController = windowScene?.windows.first!.rootViewController!
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController!) { g_user, g_error in
            if g_error != nil {
                completion(false)
                return
            }
            guard let authentication = g_user?.authentication,
                  let idToken = authentication.idToken else {
                completion(false)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            user.reauthenticate(with: credential) { result, error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    
    
    // MARK: - Apple ユーザーネーム編集
    func editUserNameApple(credential:AuthCredential,name:String,completion: @escaping (Bool) -> Void ) {
        if let user = auth.currentUser {
            auth.currentUser!.reauthenticate(with: credential) { (authResult, error) in
                guard error != nil else {
                    
                    let request = user.createProfileChangeRequest()
                    request.displayName = name
                    request.commitChanges { error in
                        if error == nil{
                            self.databaseManager.updateUsername(uid: user.uid, name: user.displayName!) // DB更新処理
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                    return
                }
                completion(false)
            }
        }
    }
    
}
// MARK: - Google & Apple
