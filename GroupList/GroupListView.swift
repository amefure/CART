//
//  GroupListView.swift
//  CART
//
//  Created by t&a on 2022/11/19.
//

import SwiftUI

struct GroupListView: View {
    
    // MARK: - インスタンス
    var authManager = AuthManager.shared
    @EnvironmentObject var databaseManager:DatabaseManager
    
    // MARK: - プロパティ
    @State var isEmptyData:Bool = false // データが本当に空かどうかの識別フラグ
    
    // MARK: - データが本当にない場合の表示を調整
    func checkEmptyData(){
        let mainQ = DispatchQueue.main
        mainQ.asyncAfter ( deadline: DispatchTime.now() + 1.5) {
            // 非同期で1.5秒後に実行される
            if databaseManager.groupArray.count == 0{
                print("maiQ")
                isEmptyData = true
            }
        }
    }
    
    var body: some View {
        VStack(spacing:0){
//            
//            VStack{
//                Text("UserId：\(UserDefaultsManager().getUserId())")
//                Text("UserName：\(UserDefaultsManager().getUserName())")
//                Text("ShareId：\(UserDefaultsManager().getShareUserId())")
//                Text("ShareName：\(UserDefaultsManager().getShareUserName())")
//            }
            
            // MARK: - グループ追加InputBox
            InputView(group:nil).environmentObject(databaseManager)
            
            // MARK: - グループ表示リスト
            List{
                Section(header:Text("\(Image(systemName: "cart.fill")) Group")){
                    
                    if databaseManager.groupArray.count == 0{
                        // MARK: - データがない場合のデモ表示
                        if isEmptyData {
                            Text("お買い物グループがありません...").listRowBackground(Color.clear).foregroundColor(.gray)
                        }else{
                            ProgressView()
                            ProgressView()
                            ProgressView()
                            ProgressView()
                            ProgressView()
                            ProgressView()
                        }
                    }else{
                        // MARK: - データ表示
                        ForEach(databaseManager.groupArray.sorted(by: {$0.id > $1.id})){ group in
                            GroupRowView(group: group)
                        }.onDelete(perform: { index in
                            // 削除するデータを取得&処理
                            let item = databaseManager.groupArray.sorted(by: {$0.id > $1.id})[index.first!]
                            databaseManager.removeGroup(group: item)
                            checkEmptyData() // データが空になっていないかチェック
                        })
                    }
                }
            }.listStyle(.grouped)
            // MARK: - グループ表示リスト
            
            // MARK: - AdMob
            AdMobBannerView().frame(height:60)
        }.navigationBarTitle("戻る")
        .navigationBarHidden(true)
        .onAppear{
            if databaseManager.groupArray.count == 0 {
                // データをネットワーク接続によってサーバーorローカルから呼び出し
                databaseManager.checkConnectedCallLoading()
            }
            checkEmptyData() // データが空になっていないかチェック
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
