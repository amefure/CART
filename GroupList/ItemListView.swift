//
//  ItemListView.swift
//  CART
//
//  Created by t&a on 2022/11/19.
//

import SwiftUI

struct ItemListView: View {
    // MARK: - インスタンス
    @EnvironmentObject var databaseManager:DatabaseManager
    
    // MARK: - receive
    var group:ShoppingGroup
    
    // MARK: - プロパティ
    @State var isClick:Bool = false // グループ名編集ボタンの押下フラグ
    @State var text:String = ""     // TextField
    
    // MARK: - メソッド
    func shoppedAllDelete(){
        let shoppedList = group.list.filter({$0.shopped == true})
        databaseManager.removeShoppedItem(group: group, items: shoppedList)
    }
    
    // MARK: - dismiss
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing:0){
            
            // MARK: - NavigationHeader
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    HStack{
                        if #available(iOS 16.0, *) {
                            Image(systemName: "chevron.backward").fontWeight(.bold)
                        } else {
                            Image(systemName: "chevron.backward")
                        }
                        Text("戻る")
                    }
                }).padding(.leading,15)
                
                Spacer()
                
                Button(action: {
                    shoppedAllDelete()
                }, label: {
                    Image(systemName: "trash")
                        .font(.system(size: 13))
                        .frame(width: 30, height: 30)
                        .background(group.list.filter({$0.shopped == true}).count != 0 ? Color("SubColor") : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }).padding(.trailing,15)
                    .compositingGroup()
                    .shadow(color: group.list.filter({$0.shopped == true}).count != 0 ? .gray : .clear, radius: 3, x: 2, y: 2)
                
            }.padding(.top,5)
            
            // MARK: - グループ名表示 & 編集フィールド
            HStack{
                
                VStack(spacing:3){
                    if isClick{
                        // MARK: - 編集フィールド
                        TextField(group.name,text: $text).textFieldStyle(.roundedBorder)
                    }else{
                        // MARK: - グループ名表示
                        Text(group.name).fontWeight(.bold).lineLimit(1)
                    }
                    // MARK: - 下線
                    Rectangle().frame(width:270,height: 1).foregroundColor(Color("SubColor"))
                    
                }.frame(width:270,height: 60).font(.system(size: 28)).foregroundColor(.gray)
                
                // MARK: - 編集切り替えボタン
                Button(action: {
                    if isClick {
                        if text != ""{
                            // 空じゃなければ更新
                            databaseManager.updateGroup(group: group, name: text)
                        }
                    }
                    isClick.toggle()
                }, label: {
                    Image(systemName: isClick ? "arrow.triangle.2.circlepath" : "square.and.pencil")
                })
            }
            // MARK: - グループ名表示 & 編集フィールド
            
            // MARK: - アイテム追加InputBox
            InputView(group: group).environmentObject(databaseManager)
            
            // MARK: - アイテム表示リスト
            List{
                ForEach(group.list.sorted(by: {$0.id > $1.id})){ item in
                    ItemRowView(group: group,item:item)
                }.onDelete(perform: { index in
                    let item = group.list.sorted(by: {$0.id > $1.id})[index.first!]
                    databaseManager.removeItem(group: group, item: item)
                })
                
            }.listStyle(.grouped)
            // MARK: - アイテム表示リスト
            
            Spacer()
            
            // MARK: - AdMob
            AdMobBannerView().frame(height:60)
            
        }.navigationBarHidden(true)

    }
}


