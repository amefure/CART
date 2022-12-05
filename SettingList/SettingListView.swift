//
//  UserSettingView.swift
//  CART
//
//  Created by t&a on 2022/11/23.
//

import SwiftUI

struct SettingListView: View {
    
    // MARK: - インスタンス
    var authManager = AuthManager.shared
    var userDefaultsManager = UserDefaultsManager()
    @EnvironmentObject var databaseManager:DatabaseManager
        
    var body: some View {
        VStack(spacing:0){
            
            List{
                
                // MARK: - ユーザー情報表示
                Section(header:Text("\(Image(systemName: "person.fill"))  User")){
                    HStack{
                        Text(userDefaultsManager.getPrefixUserName())
                            .BackRoundColor(color: Color("ThemaColor"))
                        Text(userDefaultsManager.getUserName())
                    }
                }
                
                // MARK: - 設定リスト
                Section(header:Text("\(Image(systemName: "gearshape.2.fill"))  設定")){
                    
                    // MARK: - 1
                    NavigationLink(destination: {
                        ShareDataView().environmentObject(databaseManager)
                    }, label: {
                        HStack{
                            Image(systemName: "shareplay").frame(width:30)
                            Text("データを共有する")
                        }
                    })
                    
                    // MARK: - 2
                    NavigationLink(destination: {
                        ShareMemberView().environmentObject(databaseManager)
                    }, label: {
                        HStack{
                            Image(systemName: "person.3.sequence.fill").frame(width:30)
                            Text("共有しているメンバー")
                        }
                    })
                    
                    // MARK: - 3
                    NavigationLink(destination: {
                        UserSettingView()
                    }, label: {
                        HStack{
                            Image(systemName: "person.text.rectangle").frame(width:30)
                            Text("ユーザー設定")
                        }
                    })
                    
                }
            }.listStyle(.grouped)
            
            AdMobBannerView().frame(height:60)
        }.navigationBarTitle("アカウント")
        .navigationBarHidden(true)
    }
}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingListView()
    }
}
