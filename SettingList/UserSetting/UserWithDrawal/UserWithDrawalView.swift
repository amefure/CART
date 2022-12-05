//
//  UserWithDrawalView.swift
//  CART
//
//  Created by t&a on 2022/11/26.
//

import SwiftUI

// 各ユーザー退会処理用
struct UserWithDrawalView: View {
    
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    let loginProvider = UserDefaultsManager().getLoginProvider()
    
    // MARK: - Binding
    @Binding var isActive:Bool                // ログインへの画面遷移
    @Binding var isWithDrawalAlert:Bool       // 退会アラートの発火フラグ
    
    // MARK: - プロパティ
    @State var isPasswordAlert:Bool = false   // パスワード入力アラート
    @State var pass:String = ""               // TextField
    
    // MARK: - アラートメッセージ
    @State var message:String = "ログインパスワードを入力してください。"
    
    // MARK: - Apple Navigation
    @State var isAppleView:Bool = false
    
    var body: some View {
        
        VStack{
            // MARK: - Emailユーザー専用　TextFieldAlert
            TextFieldAlertView(isActive: $isActive,
                               text: $pass,
                               isShowingAlert: $isPasswordAlert,
                               placeholder: "password",
                               isSecureTextEntry: true,
                               title: "確認",
                               message: message,
                               leftButtonTitle: "キャンセル",
                               rightButtonTitle: "実行",
                               rightButtonAction: {
                // rightButtonAction
                authManager.withdrawalEmail(pass: pass) { result in
                    if result {
                        message = "ログインパスワードを入力してください。"
                        isActive = true // 退会処理成功後ログイン画面へ
                    }else{
                        message = "パスワードが間違っています。\n正しいパスワードを入力してください。"
                        isPasswordAlert = true
                    }
                }
                // rightButtonAction
                
            }).frame(height: 0)
            // MARK: - Emailユーザー専用 TextFieldAlert
            
            
            // MARK: - Appleユーザー専用　Navigation
            NavigationLink(isActive: $isAppleView, destination: {
                AppleUserWithDrawalView(isActive: $isActive)
            }, label: {
                EmptyView()
            })
            // MARK: - Appleユーザー専用　Navigation
            
        }
        // MARK: - 退会アラート ボタン押下でプロバイダごとに処理分岐
        .alert("注意", isPresented: $isWithDrawalAlert) {
            
            Button(role: .destructive, action: {
                
                // MARK: - Email
                if loginProvider == 0{
                    isPasswordAlert = true // パスワード入力アラート表示後再認証処理
                    
                // MARK: - Google
                }else if loginProvider == 1 {
                    // Googleアカウントの場合はブラウザを介して再認証処理
                    authManager.withdrawalGoogle { result in
                        if result {
                            isActive = true // 画面遷移
                        }
                    }
                    
                // MARK: - Apple
                }else if loginProvider == 2 {
                    // Appleの場合はサインインボタン画面に飛ばす
                    isAppleView = true
                }
            }, label: {
                Text("退会する")
            })
        } message: {
            Text("このユーザーを退会すると保存していたデータは全て失われます。\nまた共有していたユーザーとの連携も解除されてしまうので注意してください。")
        }
    }
}


