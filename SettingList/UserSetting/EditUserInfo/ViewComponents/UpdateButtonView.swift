//
//  UpdateButtonView.swift
//  CART
//
//  Created by t&a on 2022/12/03.
//

import SwiftUI

struct UpdateButtonView:View{
    
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    
    let loginProvider = UserDefaultsManager().getLoginProvider()
    
    // MARK: - Input
    let name:String
    
    // MARK: - Flag
    @Binding var isPasswordAlert:Bool   // パスワード入力アラート
    @Binding var isSuccessAlert:Bool    // 更新成功アラート
    @Binding var isClick:Bool           // ログインボタンを押されたかどうか
    
    // MARK: - parent method
    let isEmailEdit: () -> Bool
    let validationInput: () -> Bool
    
    func enableButton() -> Bool{
        return (!isEmailEdit() || !validationInput())
    }
    
    var body: some View {
        VStack{
            
            // MARK: - ボタン
            if isClick {
                
                // MARK: - 処理中...
                ProgressView()
                    .frame(width:70)
                    .padding()
                    .background(Color("SubColor"))
                    .tint(.white)
                    .cornerRadius(5)
                
            }else{
                
                // MARK: - 更新ボタン
                if loginProvider == 2 {
                    // MARK: - Apple
                    Text("Appleで再認証を行うと更新されます。")
                    if validationInput(){
                        AppleAuthView(isActive: $isSuccessAlert,userEditReauthName:name,userWithDrawa: false)
                        
                    }else{
                        // 無効なボタンのデモビュー
                        Text("\(Image(systemName: "applelogo"))")
                            .frame(width: 200, height: 40)
                            .background(.gray)
                            .cornerRadius(5)
                            .foregroundColor(.white)
                    }
                    // MARK: - Apple
                }else{
                    
                    // MARK: - Email & Google
                    Button(action: {
                        isClick = true
                        
                        // MARK: - Email
                        if loginProvider == 0{
                            isPasswordAlert = true // パスワード入力アラート表示後再認証処理
                            
                        // MARK: - Google
                        }else if loginProvider == 1 {
                            // Googleアカウントの場合はブラウザを介して再認証処理
                            authManager.editUserInfoGoogle(name: name) { result in
                                if result {
                                    isSuccessAlert = true
                                }else{
                                    isClick = false
                                }
                            }
                        }
                        
                    }, label: {
                        Text("更新")
                            .frame(width:70)
                            .padding()
                            .background((enableButton() ? .gray : Color("SubColor")))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }).disabled(enableButton())
                    // MARK: - Email & Google
                }
            }
            // MARK: - ボタン
        }
    }
}
