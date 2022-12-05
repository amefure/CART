//
//  ForcedReleaseMemberButton.swift
//  CART
//
//  Created by t&a on 2022/11/27.
//

import SwiftUI

// HostUser Only View
struct ForcedReleaseMemberButton: View {
    
    // MARK: - インスタンス
    let userDefaultsManager = UserDefaultsManager()
    @EnvironmentObject var databaseManager:DatabaseManager
    
    // MARK: - Flag
    @State var isReleaseAlert:Bool = false  // シェア解除アラート
    
    var body: some View {
        // MARK: - Flag メンバーが"０"じゃない && シェアホストが"unknown"じゃない
        if databaseManager.memberDic.count != 0 && userDefaultsManager.getShareUserId() == "unknown" {
            
            // MARK: - Button
            Section(header:Text("\(Image(systemName: "rectangle.inset.filled.and.person.filled"))  ATTENTION"),footer:Text("共有しているメンバーを強制的に解放します。")){
                Button(action: {
                    isReleaseAlert = true
                }, label: {
                    Text("共有解除")
                })
            } // MARK: - 解除時
            .alert("警告", isPresented: $isReleaseAlert) {
                Button(role: .destructive, action: {
                    databaseManager.ForcedReleaseMember()
                }, label: {
                    Text("解除する")
                })
            } message: {
                Text("共有しているメンバーが強制解除されますがよろしいですか？")
            }
        }
    }
}

struct ForcedReleaseMemberButton_Previews: PreviewProvider {
    static var previews: some View {
        ForcedReleaseMemberButton()
    }
}
