//
//  LoginAuthView.swift
//  CART
//
//  Created by t&a on 2022/11/17.
//

import SwiftUI

struct LoginAuthView: View {
    
    // MARK: - インスタンス
    var authManager = AuthManager.shared
    
    // MARK: - Inputプロパティ
    @State  var email:String = ""
    @State  var password:String = ""
    
    // MARK: - Navigationプロパティ
    @State  var isActive:Bool = false
        
    var body: some View {
        VStack{
            
            // MARK: - エラーメッセージ
            ErrorMessageView()
            
            // MARK: - InputBox
            TextField("メールアドレス", text: $email).padding().textFieldStyle(.roundedBorder)
            SecureInputView(password: $password)
            
            // MARK: - パスワードリセット画面遷移ボタン
            HStack{
                Spacer()
                NavigationLink(destination: PasswordResetView(), label: {
                    Text("パスワードを忘れた場合").font(.system(size: 15))
                }).padding(.trailing)
                
            }
            
            // MARK: - ログインボタン
            AuthButtonView(isActive: $isActive, name: nil, email: email, password: password)
        

            // MARK: - 透明のNavigationLink
            NavigationLink(isActive: $isActive, destination:{ MainTabViewView()}, label: {
                EmptyView()
            })
           
            
            Text("または").padding()
            
            // MARK: - Googleアカウントログイン
            GoogleAuthView(isActive: $isActive)
            
            // MARK: - Apple IDログイン
            AppleAuthView(isActive: $isActive,userEditReauthName:"",userWithDrawa: false)
            // MARK: - 未登録遷移ボタン
            HStack{
                Spacer()
                NavigationLink(destination: EntryAuthView(), label: {
                    Text("未登録の方はこちら").font(.system(size: 15))
                }).padding(.trailing)
            }
            
        }.navigationBarHidden(true)
            .onAppear{
                authManager.errMessage = ""
            }
    }
}

struct LoginAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAuthView()
    }
}
