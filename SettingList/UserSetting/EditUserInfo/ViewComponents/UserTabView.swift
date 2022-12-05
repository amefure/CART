//
//  UserTabView.swift
//  CART
//
//  Created by t&a on 2022/12/03.
//

import SwiftUI

struct UserTabView:View{
    
    // MARK: - View
    @Binding var tabView:Int
    
    let deviceWidth = UIScreen.main.bounds.width - 40
    
    var body: some View{
        // MARK: - TabView
        HStack(spacing:0){
            
            // MARK: - ユーザー名
            Button(action: {
                tabView = 0
            }, label: {
                Text("ユーザー名").fontWeight(.bold)
            }).padding()
                .frame(width:deviceWidth/2)
                .background(tabView == 0 ? Color("SubColor") : .clear)
                .foregroundColor(tabView == 0 ? .white : Color("SubColor"))
            
            // MARK: -　メールアドレス
            Button(action: {
                tabView = 1
            }, label: {
                Text("メールアドレス").fontWeight(.bold)
            }).padding()
                .frame(width:deviceWidth/2)
                .background(tabView == 1 ? Color("SubColor") : .clear)
                .foregroundColor(tabView == 1 ? .white : Color("SubColor"))
            
        }.frame(width:deviceWidth).border(Color(red: 0.5, green: 0.5, blue: 0.5), width: 3).cornerRadius(5)
        // MARK: - TabView
    }
}






