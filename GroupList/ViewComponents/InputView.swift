//
//  InputItemView.swift
//  CART
//
//  Created by t&a on 2022/11/21.
//

import SwiftUI

struct InputView: View {
    
    // MARK: - インスタンス
    var validationManager = ValidationManager()
    @EnvironmentObject var databaseManager:DatabaseManager
    
    // MARK: - プロパティ
    var group:ShoppingGroup?    // nilかどうかで呼び出し元を識別
    @State var name:String = ""
    
    var body: some View {
        HStack{
            
            // MARK: - InputBox
            TextField((group != nil) ? "買うもの" : "グループ名" , text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            // MARK: - Button
            Button(action: {
                
                // 空白バリデーション
                if validationManager.validateEmpty(str: name) {
                    if group != nil{
                        // アイテムを追加
                        databaseManager.createItem(group: group!, name: name)
                    }else{
                        // グループを追加
                        databaseManager.createGroup(name: name)
                    }
                    name = ""
                }
            }, label: {
                Image(systemName: "cart.fill.badge.plus")
                    .font(.system(size: 20))
                    .frame(width: 60, height: 40)
                    .background(Color("ThemaColor"))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }).padding(.trailing)
                .compositingGroup()
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
        }
    }
}


