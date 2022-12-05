//
//  AppleAuthView.swift
//  CART
//
//  Created by t&a on 2022/11/30.
//
//


import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

// UserSetting > EditUserInfo > UpdateButtonView
// UserSetting > EditUserInfo > AppleUserWithDrawalView

struct AppleAuthView: View {
    
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    
    // MARK: - Navigationプロパティ
    @Binding var isActive:Bool
    
    // MARK: -
    let userEditReauthName:String // 変更するユーザー名 or ブランク("")
    
    // MARK: - Flag
    let userWithDrawa:Bool        // AppleUserWithDrawalViewから呼び出されているか
    
    // MARK: - Appleボタン　ボタンタイトル表示用
    var displayButtonTitle:SignInWithAppleButton.Label{
        if userEditReauthName == "" {
            return .signIn
        }else{
            return .continue
        }
    }
    
    // MARK: - Firebase用
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // MARK: - Firebase用
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
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
    
    // MARK: - Firebase用
    @State var currentNonce:String?
    
    var body: some View {
        
        
        SignInWithAppleButton(displayButtonTitle) { request in
            
            // MARK: - Request
            request.requestedScopes = [.email,.fullName]
            let nonce = randomNonceString() // Firebase
            currentNonce = nonce            // Firebase
            request.nonce = sha256(nonce)   // Firebase
            
        } onCompletion: { result in
            
            // MARK: - Result
            switch result {
                
            case .success(let authResults):
                let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential
                
                guard let nonce = currentNonce else {
                    return
                    //                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential?.identityToken else {
                    //                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    //                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                
                
                // MARK: - 以下ボタンアクション分岐
                
                //
                if userEditReauthName == ""{
                    
                    if userWithDrawa == false {
                        // MARK: - ログイン
                        authManager.loginCredential(credential: credential,isApple: true) { result in
                            if result {
                                isActive = true // 画面遷移
                            }
                        }
                    }else{
                        // MARK: - 退会
                        authManager.withdrawal { result in
                            if result {
                                isActive = true // EditUserInfo成功アラート表示用
                            }
                        }
                    }
                    
                }else{
                    // MARK: - ユーザーネーム変更
                    authManager.editUserNameApple(credential: credential,name: userEditReauthName) { result in
                        if result {
                            isActive = true // EditUserInfo成功アラート表示用
                        }
                    }
                }
                
            case .failure(let error):
                //                print("Authorisation failed: \(error.localizedDescription)")
                break
            }
        }.frame(width: 200, height: 40)
            .signInWithAppleButtonStyle(.black)
    }
}



