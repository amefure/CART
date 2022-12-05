//
//  OtherShareUserIdView.swift
//  CART
//
//  Created by t&a on 2022/12/04.
//

import SwiftUI

struct OtherShareUserIdView:View{
    // MARK: - インスタンス
    let authManager = AuthManager.shared
    let userDefaultsManager = UserDefaultsManager()
    let validationManager = ValidationManager()
    @EnvironmentObject var databaseManager:DatabaseManager
    
    // MARK: - View用
    let deviceWidth = UIScreen.main.bounds.width
    
    // MARK: - プロパティ
    @State var resultMsg:String = ""        // シェアリサルトメッセージ格納用
    
    // MARK: - Flag
    @State var invitationCode:String = ""   // 招待コードTextField
    @State var isShareAlert:Bool = false    // シェアアラート
    @State var isReleaseAlert:Bool = false  // シェア解除アラート
    
    
    var body: some View {
        
        VStack(spacing:0){
            
            
            // MARK: - 他人のデータを共有

            VStack{
                
                // MARK: - Header
                HStack{
                    Image(systemName: userDefaultsManager.getShareUserId() == "unknown" ? "creditcard.and.123" : "person.fill.checkmark")
                    Text(userDefaultsManager.getShareUserId() == "unknown" ? "招待コードを入力" : "\(userDefaultsManager.getShareUserName())さんと連携中")
                        .fontWeight(.bold)
                }.frame(width:deviceWidth - 30)
                    .padding()
                    .background(Color("ThemaColor"))
                    .foregroundColor(.white)
                // MARK: - Header
                
                // MARK: - Body
                HStack(spacing:0){
                    // MARK: - シェア状況によって分岐
                    if userDefaultsManager.getShareUserId() != "unknown"{
                        // MARK: - シェアしている場合は解除処理
                        Text(userDefaultsManager.getShareUserId())
                            .textSelection(.enabled)
                            .padding([.leading,.trailing])
                            .frame(width: deviceWidth - 100)
                            .lineLimit(1)
                        
                        // MARK: - 解除ボタン
                        Button(action: {
                            databaseManager.removeShareUser()
                            databaseManager.loadingData()
                            isReleaseAlert = true
                        }, label: {
                            Text("解除")
                        }).padding(5)
                            .background(Color("SubColor"))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.trailing)
                        
                    }else{
                        // MARK: - 未シェア場合はシェア処理
                        TextField("他ユーザーの招待コードを入力",text: $invitationCode).padding([.leading,.trailing]).frame(width: deviceWidth - 100)
                        Button(action: {
                            databaseManager.checkShareUserId(shareUid:invitationCode) { resultMsg in
                                if resultMsg == "招待コードが承認されました。" {
                                    databaseManager.entryShareUser(shareUid:invitationCode)
                                    databaseManager.loadingData()
                                }
                                self.resultMsg = resultMsg
                                isShareAlert = true
                            }
                        }, label: {
                            Text("連携")
                        }).padding(5)
                            .background(validationManager.validateEmpty(str: invitationCode) ?  Color("ThemaColor") : .gray )
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.trailing)
                            .disabled(!validationManager.validateEmpty(str: invitationCode))
                    }
                    // MARK: - シェア状況によって分岐
                }.frame(width:deviceWidth - 20).padding() // HStack
                // MARK: - Body
            }.border(Color(red: 0.5, green: 0.5, blue: 0.5), width: 3)
                .padding(.bottom,50)
    
            // MARK: - 他人のデータを共有
        }// MARK: - 登録時
        .alert(resultMsg == "招待コードが承認されました。" ? "Success" : "Error..." , isPresented: $isShareAlert) {
            Button("OK") {
            }
        } message: {
            Text(resultMsg)
        }
        // MARK: - 解除時
        .alert("Release", isPresented: $isReleaseAlert) {
            Button("OK") {
            }
        } message: {
            Text("データの連携を解除しました。")
        }
        
    }
}


