//
//  AppleUserWithDrawalView.swift
//  CART
//
//  Created by t&a on 2022/12/03.
//

import SwiftUI

// Appleアカウント退会用再認証画面
struct AppleUserWithDrawalView: View {
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    @Binding var isActive:Bool // 画面遷移
    
    var body: some View {
        VStack{
            Text("退会するには以下のボタンから再認証してください。")
            AppleAuthView(isActive: $isActive, userEditReauthName: "",userWithDrawa: true)
        }
    }
}
