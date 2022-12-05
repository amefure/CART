//
//  User default.swift
//  CART
//
//  Created by t&a on 2022/11/21.
//

import SwiftUI

class UserDefaultsManager {
    
// MARK: - key   : Type          UserDefaults
//         UserId：String        ログインユーザーID
//         UserName：String      ログインユーザー名
//         ShareUserId：String   シェアユーザーID
//         ShareUserName：String シェアユーザーID
//         LoginProvider：Int    ログインプロバイダー 0 mail 1 google 2 apple
    
    // MARK: - プロパティ
    let userDefaults = UserDefaults.standard
    
    // MARK: -　リセット
    func allReset(){
        setUserId("unknown")
        setUserName("unknown")
        setShareUserId("unknown")
        setShareUserName("unknown")
        setLoginProvider(0)
    }
     
    // MARK: - Set user
    func setUserId(_ id:String){
        userDefaults.set(id, forKey: "UserId")
    }
    
    func setUserName(_ name:String){
        userDefaults.set(name, forKey: "UserName")
    }

    // MARK: - Set Share
    func setShareUserId(_ id:String){
        userDefaults.set(id, forKey: "ShareUserId")
    }
    
    func setShareUserName(_ name:String){
        userDefaults.set(name, forKey: "ShareUserName")
    }
    
    // MARK: - Set Google Flag
    func setLoginProvider(_ flag:Int){
        userDefaults.set(flag, forKey: "LoginProvider")
    }
    
    
    // MARK: - Get user
    func getUserId() -> String{
        userDefaults.string(forKey: "UserId") ?? "unknown"
    }
    
    func getUserName() -> String{
        userDefaults.string(forKey: "UserName") ?? "unknown"
    }
    // MARK: - ShareMemberView　表示用
    func getPrefixUserName() -> String{
        let name = userDefaults.string(forKey: "UserName") ?? "unknown"
        return String(name.prefix(2))
    }
    
    // MARK: - Get Share
    func getShareUserId() -> String{
        userDefaults.string(forKey: "ShareUserId") ?? "unknown"
    }
    
    func getShareUserName() -> String{
        userDefaults.string(forKey: "ShareUserName") ?? "unknown"
    }
    
    // MARK: - ShereMemberView Host表示
    func getPrefixShareUserName() -> String{
        var name = userDefaults.string(forKey: "ShareUserName") ?? "unknown"
        if name == "unknown"{
            // Hostアカウントの場合(ShareUserNameに値が未格納)はアカウント名を表示
            name = getUserName()
        }
        return String(name.prefix(2))
    }

    // MARK: - Get Google Flag
    func getLoginProvider() -> Int{
        userDefaults.integer(forKey: "LoginProvider")
    }
}
