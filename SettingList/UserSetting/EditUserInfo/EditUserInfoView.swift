//
//  EditUserInfoView.swift
//  CART
//
//  Created by t&a on 2022/11/28.
//

import SwiftUI

struct EditUserInfoView: View {
    
    // MARK: - インスタンス
    let validation = ValidationManager()
    
    // MARK: - Input
    @State var name:String = ""
    @State var email:String =  ""
    
    // MARK: - View
    @State var tabView:Int = 0
    
    // MARK: - Flag
    @State var isPasswordAlert:Bool = false   // パスワード入力アラート
    @State var isSuccessAlert:Bool = false    // 更新成功アラート
    @State var isClick:Bool = false // ログインボタンを押されたかどうか
    

    // MARK: - method
    private func isEmailEdit() -> Bool{
        if (UserDefaultsManager().getLoginProvider() == 1 || UserDefaultsManager().getLoginProvider() == 2) && tabView == 1 {
            return false // Google & Apple
        }else{
            return true  // Email
        }
    }
    
    private func validationInput() -> Bool{
        if tabView == 0{
            if validation.validateEmpty(str: name) {
                return true
            }else{
                return false
            }
        }else if tabView == 1{
            if validation.validateEmail(email: email)  {
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    var body: some View {
        VStack{
            
            // MARK: - TabView
            UserTabView(tabView: $tabView)
            // MARK: - TabView
            
            Spacer()
            
            // MARK: - Icon & TextField
            UserEditBodyView(name: $name, email: $email, tabView: tabView, isGoogleEmailEdit: isEmailEdit)
            // MARK: - Icon & TextField
            
            Spacer()
            
            
            // MARK: - Emailユーザー専用　Googleアカウント使用しない
            EmailTextFieldAlertView(name: name, email: email, tabView: tabView, isPasswordAlert: $isPasswordAlert, isSuccessAlert: $isSuccessAlert, isClick:$isClick, validationInput: validationInput)
            // MARK: - Emailユーザー専用　Googleアカウント使用しない
            
            // MARK: - 更新ボタン
            UpdateButtonView(name: name, isPasswordAlert: $isPasswordAlert, isSuccessAlert: $isSuccessAlert, isClick: $isClick, isEmailEdit: isEmailEdit, validationInput: validationInput)
            // MARK: - 更新ボタン
            
            
            Spacer()
            
            // MARK: - AdMob
            AdMobBannerView().frame(height:60)
            
        } // MARK: - 退会アラート
        .alert("Success!", isPresented: $isSuccessAlert) {
            Button("OK"){
                isClick = false
                name = ""
                email = ""
            }
        } message: {
            Text(tabView == 0 ? "ユーザー名を更新しました。" : "メールアドレスを更新しました。")
        }
    }
}

