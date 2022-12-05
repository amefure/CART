//
//  GroupRowView.swift
//  CART
//
//  Created by t&a on 2022/11/21.
//

import SwiftUI

struct GroupRowView: View {
    
    // MARK: - インスタンス
    @EnvironmentObject var databaseManager:DatabaseManager
    
    // MARK: - receive
    var group:ShoppingGroup
    
    var body: some View {
        
        NavigationLink(destination: {
            ItemListView(group: group).environmentObject(databaseManager)
        }, label: {
            VStack(alignment:.leading) {
                HStack{
                    Image(systemName: "circle")
                    Text(group.name).font(.system(size: 20))
                }.foregroundColor(.brown)
            }.textSelection(.enabled)
                .lineLimit(1)
        })
    }
}


