//
//  MyShareUserIdView.swift
//  CART
//
//  Created by t&a on 2022/12/04.
//

import SwiftUI

struct MyShareUserIdView:View{
    
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    let myUserId = UserDefaultsManager().getUserId()
    
    // MARK: - View用
    let deviceWidth = UIScreen.main.bounds.width
    
    var body: some View{
        
        // MARK: - 自分のデータを共有
        VStack{
            
            // MARK: -  Header
            HStack{
                Image(systemName: "creditcard.and.123")
                Text("自分の招待コード").fontWeight(.bold).textSelection(.enabled)
            }.frame(width:deviceWidth - 30).padding().background(Color("ThemaColor")).foregroundColor(.white)
            // MARK: - Header
            
            // MARK: - Body
            HStack(spacing:0){
                Text(myUserId).padding().foregroundColor(.gray).lineLimit(1)
                CopyTextButton(text: authManager.auth.currentUser?.uid ?? "")
            }
            // MARK: - Body
        }.border(Color(red: 0.5, green: 0.5, blue: 0.5), width: 3)
        // MARK: - 自分のデータを共有
        
    }
}



