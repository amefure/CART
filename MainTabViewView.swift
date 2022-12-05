//
//  ContentView.swift
//  CART
//
//  Created by t&a on 2022/11/17.
//

import SwiftUI

struct MainTabViewView: View {
    
    // 共有元となるインスタンス
    @ObservedObject var databaseManager = DatabaseManager.shared
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = .gray
    }
    
    @State var selectedTag = 1

    var body: some View {
        
        VStack{
           
            TabView(selection: $selectedTag){
                // MARK: - (1)
                GroupListView().environmentObject(databaseManager).tabItem({
                    Image(systemName: "cart.fill")
                    Text("買い物リスト")
                }).tag(1)
                
                // MARK: - (2)
                SettingListView().environmentObject(databaseManager).tabItem({
                    Image(systemName: "person.fill")
                    Text("アカウント")
                }).tag(2)
                
                
                // MARK: - (2)
                MenuListView().environmentObject(databaseManager).tabItem({
                    Image(systemName: "fork.knife")
                    Text("献立リスト")
                }).tag(3)
                
            }.accentColor(Color("SubColor"))
            
        }
    }
}

struct MainTabViewView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabViewView()
    }
}
