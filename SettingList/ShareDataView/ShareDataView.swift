//
//  ShareDataView.swift
//  CART
//
//  Created by t&a on 2022/11/23.
//

import SwiftUI

struct ShareDataView: View {
    
    // MARK: - インスタンス
    @EnvironmentObject var databaseManager:DatabaseManager
    
    var body: some View {
        VStack(spacing:0){
            
            Spacer()
            
            // MARK: - 他人のデータを共有
            OtherShareUserIdView().environmentObject(databaseManager)
            // MARK: - 他人のデータを共有
            
            // MARK: - 自分のデータを共有
            MyShareUserIdView()
            // MARK: - 自分のデータを共有
            
            Spacer()
            
            // MARK: - AdMob
            AdMobBannerView().frame(height:60)
        }
        
    }
}

