//
//  ItemRowView.swift
//  CART
//
//  Created by t&a on 2022/11/21.
//

import SwiftUI

struct ItemRowView: View {
    
    // MARK: - インスタンス
    @EnvironmentObject var databaseManager:DatabaseManager
    
    // MARK: - receive
    var group:ShoppingGroup
    var item:ShoppingItem
    
    // MARK: - プロパティ
    @State var isShopped:Bool = false
    
    var body: some View {
        HStack{
            // MARK: -チェックボタン
            Button(action: {
                isShopped.toggle()
                databaseManager.updateItem(group: group,item: item,name: item.name, shopped: isShopped)
            }, label: {
                Image(systemName: !item.shopped ? "app" :"checkmark.square.fill" ).font(.system(size: 20)).foregroundColor(Color("SubColor"))
            })
            // MARK: - 名称
            Text(item.name).foregroundColor(.brown)
        }
        .onAppear {
            isShopped = item.shopped
        }
    }
}


