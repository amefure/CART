//
//  AuthButtonView.swift
//  CART
//
//  Created by t&a on 2022/11/27.
//

import SwiftUI

struct AuthButtonView: View {
    
    // MARK: - インスタンス
    var authManager = AuthManager.shared
    var validation = ValidationManager()
    
    // MARK: - Navigationプロパティ
    @Binding var isActive:Bool
    
    // MARK: - Inputプロパティ
    var name:String?        // ログインView呼び出し時はnil
    var email:String
    var password:String
    
    // MARK: - プロパティ
    @State var isClick:Bool = false // ログインボタンを押されたかどうか
    
    // MARK: - バリデーション
    func validationInput()-> Bool{
        if name != nil{
            if validation.validateEmpty(str: name!) && validation.validateEmail(email: email) && validation.validatePassWord(password: password) {
                return true
            }
        }else{
            if validation.validateEmail(email: email) && validation.validatePassWord(password: password) {
                return true
            }
        }
        return false
    }
    
    
    var body: some View {
        // MARK: - ボタン
        if isClick {
            // 処理中...
            ProgressView()
                .frame(width:70)
                .padding()
                .background(Color("ThemaColor"))
                .tint(.white)
                .cornerRadius(5)
                .padding()
        }else{
            // ログインボタン
            Button(action: {
                if validationInput(){
                    isClick = true // 処理中にする
                    if name != nil{
                        authManager.createUser(email: email, password: password,name: name!) { result in
                            if result {
                                isActive = true  // 画面遷移
                            }else{
                                isClick = false  // 解除
                            }
                        }
                    }else{
                        authManager.login(email: email, password: password) { result in
                            if result {
                                isActive = true  // 画面遷移
                            }else{
                                isClick = false  // 解除
                            }
                        }
                    }
                }
            }, label: {
                Text(name != nil ? "新規登録" : "ログイン")
                    .frame(width:70)
                    .padding()
                    .background((validationInput() ? Color("ThemaColor") : .gray))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .disabled(!validationInput())
            }).padding()
        }
        
    }
}
