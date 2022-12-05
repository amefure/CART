//
//  EntryAuthView.swift
//  CART
//
//  Created by t&a on 2022/11/17.
//

import SwiftUI

struct EntryAuthView: View {
    
    // MARK: - インスタンス
    var authManager = AuthManager.shared
    
    // MARK: - Inputプロパティ
    @State  var name:String = ""
    @State  var email:String = ""
    @State  var password:String = ""
    
    // MARK: - Navigationプロパティ
    @State  var isActive:Bool = false
    
    var body: some View {
        VStack{
            
            // MARK: - 透明のNavigationLink
            NavigationLink(isActive: $isActive, destination:{ MainTabViewView()}, label: {
                EmptyView()
            })
            
            // MARK: - エラーメッセージ
            ErrorMessageView()
            
            // MARK: - InputBox
            TextField("ユーザー名", text: $name).padding().textFieldStyle(.roundedBorder)
            TextField("メールアドレス", text: $email).padding().textFieldStyle(.roundedBorder)
            SecureInputView(password: $password)
            
            // MARK: - ログインボタン
            AuthButtonView(isActive: $isActive, name: name, email: email, password: password)
            
            Text("または").padding()
            
            // MARK: - Googleアカウントログイン
            GoogleAuthView(isActive: $isActive)
            
            // MARK: - Apple IDログイン
            AppleAuthView(isActive: $isActive,userEditReauthName:"",userWithDrawa: false)
            
        }.onAppear{
            authManager.errMessage = ""
        }
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAuthView()
    }
}
