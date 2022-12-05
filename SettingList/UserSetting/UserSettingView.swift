//
//  LogOutUserView.swift
//  CART
//
//  Created by t&a on 2022/11/25.
//

import SwiftUI

struct UserSettingView: View {
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    
    // MARK: - プロパティ
    @State var isActive:Bool = false          // ログイン画面への画面遷移
    @State var isWithDrawalAlert:Bool = false // 退会アラートの発火フラグ

    var body: some View {
        VStack(spacing:0){
            
            // MARK: - 動的に動作するリンク ログアウト用
            NavigationLink(isActive: $isActive, destination: {LoginAuthView()}, label: {EmptyView()})
            
            // MARK: - リスト
            List{
                Section(header:Text("\(Image(systemName: "person.fill"))  User Setting")){
                    
                    // MARK: - 1. ユーザー名変更
                    NavigationLink(destination: {
                        EditUserInfoView()
                    }, label: {
                        HStack{
                            Image(systemName: "person.text.rectangle")
                            Text("ユーザー情報編集")
                        }.foregroundColor(.black)
                    })
                    
                    // MARK: - 2. ログアウト処理
                    Button(action: {
                        authManager.logout { result in
                            if result {
                                isActive = true
                            }
                        }
                    }, label: {
                        HStack{
                            Image(systemName: "figure.walk").frame(width:30)
                            Text("ログアウト")
                        }.foregroundColor(.black)
                    })
                    
                    // MARK: - 3. 退会処理
                    Button(action: {
                        isWithDrawalAlert = true // 退会ビューアラート
                    }, label: {
                        HStack{
                            Image(systemName: "hand.raised.fill").frame(width:30)
                            Text("退会")
                        }.foregroundColor(.black)
                    })
                    
                }
                
            }.listStyle(.grouped)
            // MARK: - 退会処理
            UserWithDrawalView(isActive: $isActive,isWithDrawalAlert: $isWithDrawalAlert)
            
            // MARK: - AdMob
            AdMobBannerView().frame(height:60)
        }
    }
}

struct LogOutUserView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
    }
}

