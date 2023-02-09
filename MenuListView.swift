//
//  MenuListView.swift
//  CART
//
//  Created by t&a on 2022/12/04.
//

import SwiftUI

struct MenuListView: View {
    
    // MARK: - インスタンス
    var authManager = AuthManager.shared
    @EnvironmentObject var databaseManager:DatabaseManager
    
    let weekDay:[String] = ["月","火","水","木","金","土","日"]

    let colorSet:[Color] = [.gray,.gray,.gray,.gray,.gray,.blue,.red]
    @State var week:[String] = ["","","","","","",""]
    
    @State var memo:String = ""
    @State var isEdit:Bool = false
    var body: some View {
        
        VStack(spacing:0){
            
            HStack{
                
                
                if isEdit {
                    Button(action: {
                        week = databaseManager.menuObj.week
                        isEdit.toggle()
                    }, label: {
                        Image(systemName: "arrow.uturn.left" )
                    }).BackRoundColor(color: Color.indigo)
                }
                
                if isEdit {
                    Button(action: {
                        week = ["","","","","","",""]
                    }, label: {
                        Image(systemName: "trash" )
                    }).BackRoundColor(color: Color("SubColor"))
                }
            
                
                
                Button(action: {
                    if isEdit {
                        // 登録処理
                        databaseManager.updateMenu(menuArray: week, memo: memo)
                    }else{
                        // TextField値格納
                        week = databaseManager.menuObj.week
                        memo = databaseManager.menuObj.memo
                    }
                    isEdit.toggle()
                    
                    
                }, label: {
                    Image(systemName: isEdit ? "checkmark" : "square.and.pencil" )
                }).BackRoundColor(color: isEdit ? .green : Color("ThemaColor"))
            }.padding(5)
            
            List{
                Section(header:Text("\(Image(systemName: "fork.knife")) 献立")){
                    
                    ForEach(weekDay.indices, id: \.self) { i in
                        HStack{
                            Text(weekDay[i]).foregroundColor(colorSet[i])
                            if isEdit{
                                TextField("", text: $week[i]).textFieldStyle(.roundedBorder)
                            }else{
                                Text(databaseManager.menuObj.week[i])
                            }
                        }
                        
                    }
                }
                Section(header:Text("\(Image(systemName: "pencil")) Memo")){
                    if isEdit{
                        TextEditor(text: $memo)
                            .frame(height:250)
                            .border(Color(red: 0.9, green: 0.9, blue: 0.9), width: 1)
                    }else{
                        Text(databaseManager.menuObj.memo).frame(minHeight:100,alignment: .top)
                    }
                    
                }
            }
            
            // MARK: - AdMob
            AdMobBannerView().frame(height:60)
        }
    }
}


