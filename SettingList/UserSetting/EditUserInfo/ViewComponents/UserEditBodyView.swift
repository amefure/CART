//
//  UserEditBody.swift
//  CART
//
//  Created by t&a on 2022/12/03.
//

import SwiftUI

struct UserEditBodyView:View{
    
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    let userDefaultsManager = UserDefaultsManager()
    
    // MARK: - Binding
    @Binding var name:String
    @Binding var email:String
    
    // MARK: - View
    let tabView:Int
    
    // parent method
    let isGoogleEmailEdit: () -> Bool
    
    var body: some View{
        if tabView == 0{
            // MARK: - UserName
            Image(systemName: "person.text.rectangle")
                .resizable()
                .frame(width:50,height: 40)
                .foregroundColor(.gray)
            
            Text("ユーザー名")
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding()
            
            TextField(userDefaultsManager.getUserName(), text: $name)
                .textFieldStyle(.roundedBorder)
                .frame(height: 60)
                .padding()
            // MARK: - Username
        }else if tabView == 1{
            // MARK: - Email
            Image(systemName: "person.crop.square.filled.and.at.rectangle")
                .resizable()
                .frame(width:50,height: 40)
                .foregroundColor(.gray)
            
            Text("メールアドレス")
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding()
            
            if !isGoogleEmailEdit() {
                Text(userDefaultsManager.getLoginProvider() == 1 ?
                     "Googleアカウントでログインしている場合は\nメールアドレスの変更はできません。" :
                        "Appleアカウントでログインしている場合は\nメールアドレスの変更はできません。")
                .frame(height: 60)
                .padding()
                
            }else{
                TextField(authManager.auth.currentUser?.email ?? "E-mail" , text: $email)
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 60)
                    .padding()
            }
            // MARK: - Email
        }
    }

    
}
