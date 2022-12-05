//
//  EmailTextFieldAlertView.swift
//  CART
//
//  Created by t&a on 2022/12/03.
//

import SwiftUI

struct EmailTextFieldAlertView:View{
    
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    
    // MARK: - Input
    let name:String
    let email:String

    // MARK: - View
    let tabView:Int
   
    // MARK: - Binding
    @Binding var isPasswordAlert:Bool
    @Binding var isSuccessAlert:Bool
    @Binding var isClick:Bool
    
    // parent method
    let validationInput: () -> Bool
    
    // MARK: - プロパティ
    @State var pass:String = ""
    @State var message:String = "ログインパスワードを入力してください。"
    
    var body: some View{
        // MARK: - Emailユーザー専用View : 描画なし
        TextFieldAlertView(isActive: Binding.constant(true),
                           text: $pass,
                           isShowingAlert: $isPasswordAlert,
                           placeholder: "password",
                           isSecureTextEntry: true,
                           title: "確認",
                           message: message,
                           leftButtonTitle: "キャンセル",
                           rightButtonTitle: "実行",
                           leftButtonAction:{ isClick = false },
                           rightButtonAction: {
            
            // rightButtonAction
            if validationInput(){
                if tabView == 0{
                    // MARK: - UserName
                    authManager.editUserInfoEmail(name: name,pass: pass) { result in
                        if result {
                            isSuccessAlert = true
                        }else{
                            message = "パスワードが間違っています。\n正しいパスワードを入力してください。"
                            isPasswordAlert = true // 再表示
                        }
                    }
                    
                }else if tabView == 1{
                    // MARK: - Email
                    authManager.updateEmail(email: email, pass: pass) { result in
                        if result {
                            isSuccessAlert = true
                        }else{
                            message = "パスワードが間違っています。\n正しいパスワードを入力してください。"
                            isPasswordAlert = true  // 再表示
                        }
                    }
                }
            }
            // rightButtonAction
            
        }).frame(height: 0)
    }
}
