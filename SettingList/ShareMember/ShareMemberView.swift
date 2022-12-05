//
//  ShareMemberView.swift
//  CART
//
//  Created by t&a on 2022/11/24.
//

import SwiftUI

struct ShareMemberView: View {
    
    // MARK: - インスタンス
    let userDefaultsManager = UserDefaultsManager()
    @EnvironmentObject var databaseManager:DatabaseManager

    var body: some View {
        
        VStack(spacing:0){
            
            List{
                
                if databaseManager.memberDic.count == 0{
                    
                    //MARK: -  データ共有していない場合
                    Section(header:Text("\(Image(systemName: "person.fill"))  User Only")){
                        Text(userDefaultsManager.getPrefixUserName())
                            .BackRoundColor(color: Color("ThemaColor"))
                    }
                    
                }else{
                    
                    //MARK: -  データ共有している場合
                    // Host User
                    Section(header:Text("\(Image(systemName: "rectangle.inset.filled.and.person.filled")) Host")){
                        Text("\(userDefaultsManager.getPrefixShareUserName())")
                            .BackRoundColor(color: Color("SubColor"))
                    }
                    
                    
                    // Member User　昇順にソート
                    let sorted: [(key: String, value: String)] = databaseManager.memberDic.sorted { $0.key < $1.key}
                    
                    Section(header:Text("\(Image(systemName: "person.2.fill")) Member")){
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(sorted, id: \.key) { user in
                                    Text(user.value.prefix(2))
                                        .BackRoundColor(color: Color("ThemaColor"))
                                        .padding(5)
                                }
                            }
                        }
                    }
                }
                
                // MARK: - メンバー強制解放ボタン Hostのみ表示
                ForcedReleaseMemberButton().environmentObject(databaseManager)
                
            }.listStyle(.grouped)

            AdMobBannerView().frame(height:60)
        }
        
    }
}

struct ShareMemberView_Previews: PreviewProvider {
    static var previews: some View {
        ShareMemberView()
    }
}
