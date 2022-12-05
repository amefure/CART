//
//  DatabaseManager.swift
//  CART
//
//  Created by t&a on 2022/11/19.
//

import UIKit
import FirebaseDatabase
import SwiftUI

class DatabaseManager:ObservableObject{
    
    // MARK: シングルトン
    static let shared = DatabaseManager()
    
    // MARK: インスタンス
    let userDefaultsManager = UserDefaultsManager()
    
    // MARK: リファレンス
    let ref: DatabaseReference! = Database.database().reference()
    
    // MARK: データベースのグループリファレンスパス
    var groupRef:DatabaseReference!{
        ref.child("users").child(currentUserID).child("group")
    }
    
    // MARK: データベースのメニューリファレンスパス
    var menuRef:DatabaseReference!{
        ref.child("users").child(currentUserID).child("menu")
    }
    
    // MARK: データ表示するべきユーザーID
    var currentUserID:String{
        let shareUid = userDefaultsManager.getShareUserId()
        let uid = userDefaultsManager.getUserId()
        if shareUid != "unknown"{
            return shareUid
        }else{
            return uid
        }
    }
    
    // MARK: 共有観測プロパティ
    @Published var groupArray:[ShoppingGroup] = []   // 買い物リストデータ格納
    @Published var memberDic:[String:String] = [:] // シェアメンバー格納
    @Published var menuObj:Menu = Menu(week: ["","","","","","",""], memo: "")           // メニュー格納
    
    // MARK: - 以下メソッド
    func initDic(){
        // call AuthManager.swift > logoutFunction
        self.groupArray = []   // 初期化
        self.memberDic = [:] // 初期化
        self.menuObj = Menu(week: ["","","","","","",""], memo: "")
    }
    
    // MARK: 1.User
    // MARK: 2.Group
    // MARK: 3.Item
    // MARK: 4.Share
    // MARK: 5.Fetch Data
    // MARK: 6.Menu
    
    // MARK: - 1.User
    // MARK: User 登録処理
    func createUser(uid:String,name:String){
        // Googleユーザーとして登録済みでないか
        self.checkGoogleUser(uid: uid) { entryBool in
            if !entryBool {
                // 未登録ならDBに登録
                self.ref.child("users").child(uid).child("userName").setValue(name)
            }
        }
        self.userDefaultsManager.setUserId(uid)   // UserDefaults登録
        self.userDefaultsManager.setUserName(name)
    }
    
    // MARK: UserName 更新処理
    func updateUsername(uid:String,name:String){
        let shareUid = self.userDefaultsManager.getShareUserId()
        var updateItems:[String:String] = [:]
        
        if  shareUid != "unknown"{
            // シェアされている(Member)ならユーザー名とメンバー名を一括更新
            updateItems.updateValue(name, forKey: "\(uid)/userName")           // ユーザー名
            updateItems.updateValue(name, forKey: "\(shareUid)/member/\(uid)") // メンバー名
            ref.child("users").updateChildValues(updateItems)
        }else{
            if self.memberDic.count != 0 {
                // シェアしている(Host)ならユーザー名とHost名を一括更新
                let hostId = self.userDefaultsManager.getUserId()
                updateItems.updateValue(name, forKey: "\(uid)/userName") // ユーザー名
                for (memberId,_) in self.memberDic {
                    updateItems.updateValue(name, forKey: "\(memberId)/shareHost/\(hostId)") // Host名
                }
                ref.child("users").updateChildValues(updateItems)
                
            }else{
                // 誰ともシェアしていない
                ref.child("users").child(uid).child("userName").setValue(name)
            }
        }
        self.userDefaultsManager.setUserName(name)
    }
    
    // MARK: User 退会処理
    func removeUser(){
        let id = userDefaultsManager.getUserId()
        let shareUid = userDefaultsManager.getShareUserId()
        
        var removeItems:[String:Any?] = [:]
        removeItems.updateValue(nil, forKey: "\(shareUid)/member/\(id)")
        removeItems.updateValue(nil, forKey: "\(id)")
        ref.child("users").updateChildValues(removeItems as [AnyHashable : Any] )
        userDefaultsManager.allReset() // UserDefaultsリセット
    }
    
    // MARK: Googleログイン時登録済みチェック
    private func checkGoogleUser(uid:String,completion:@escaping (Bool) -> Void ) {
        ref.child("users").child(uid).getData(completion:  { error, snapshot in
            guard error == nil else {
                return
            }
            if snapshot?.value is [String:AnyObject] {
                // print("登録済み")
                completion(true)
            }else{
                // print("未登録")
                completion(false)
            }
        })
    }
    // MARK: - 1.User
    
    // MARK: - 2.Group
    func createGroup(name:String){
        groupRef.childByAutoId().child("name").setValue(name)
    }
    
    func updateGroup(group:ShoppingGroup,name:String){
        groupRef.child(group.id).child("name").setValue(name)
    }
    
    func removeGroup(group:ShoppingGroup){
        groupRef.child(group.id).removeValue()
    }
    // MARK: - 2.Group
    
    // MARK: - 3.Item
    func createItem(group:ShoppingGroup,name:String){
        let itemRef = groupRef.child(group.id).child("list").childByAutoId()
        
        var createItems:[String:Any?] = [:]
        createItems.updateValue(name, forKey: "name")
        createItems.updateValue(false, forKey: "shopped")
        itemRef.updateChildValues(createItems as [AnyHashable : Any] )
        
    }
    
    func updateItem(group:ShoppingGroup,item:ShoppingItem,name:String,shopped:Bool){
        let itemRef = groupRef.child(group.id).child("list").child(item.id)
        
        var updateItems:[String:Any?] = [:]
        updateItems.updateValue(name, forKey: "name")
        updateItems.updateValue(shopped, forKey: "shopped")
        itemRef.updateChildValues(updateItems as [AnyHashable : Any] )
        
    }
    
    func removeItem(group:ShoppingGroup,item:ShoppingItem){
        groupRef.child(group.id).child("list").child(item.id).removeValue()
    }
    
    // shoppedフラグのついている要素を全て削除する
    func removeShoppedItem(group:ShoppingGroup,items:[ShoppingItem]){
        var removeItems:[String:Any?] = [:]
        for item in items {
            removeItems.updateValue(nil, forKey: item.id)
        }
        groupRef.child(group.id).child("list").updateChildValues(removeItems as [AnyHashable : Any] )
    }
    // MARK: - 3.Item
    
    // MARK: - 4.Share
    // call SettingList > ShareDataView
    // シェア用に渡されたコードが存在するかを識別 エラーメッセージを返す
    func checkShareUserId(shareUid:String,completion:@escaping (String) -> Void ) {
        let validateCode = removeInvalidText(text: shareUid)
        // 自身のIDと一致しているかチェック
        if validateCode != userDefaultsManager.getUserId() {
            
            if self.memberDic.count == 0 {
                
                ref.child("users").child(validateCode).getData(completion:  { error, snapshot in
                    guard error == nil || snapshot != nil else {
                        completion("有効でない招待コードです。\n確認の上再度入力ください。")
                        return
                    }
                    // 指定されたユーザーデータが存在するかどうか
                    if let data = snapshot?.value as? [String:AnyObject]{
                        // 共有相手が誰ともシェアしていないかどうか
                        if data["shareHost"] == nil {
                            //誰とも共有していない場合はUser名を取得し格納
                            if let name = data["userName"]{
                                self.userDefaultsManager.setShareUserName(name as! String)
                                completion("招待コードが承認されました。")
                            }
                        }else{
                            if let host = data["shareHost"] as? Dictionary<String, String>{
                                completion("対象ユーザーは\n既に「\(host.values.first!)さん」と\nデータを共有済みです。")
                            }else{
                                completion("有効でない招待コードです。\n確認の上再度入力ください。")
                            }
                        }
                    }else{
                        completion("有効でない招待コードです。\n確認の上再度入力ください。")
                    }
                })
            }else{
                completion("既に自身のデータを\n共有しているメンバーが存在します。\n\n【共有方法】\n1.各メンバーの連携を解除してもらう\n2.「共有しているメンバー」から共有を強制解除する\n")
            }
        }else{
            completion("自分の招待コードは使用できません。")
        }
    }
    
    // 入力値に対するバリデーション：エラー対策
    private func removeInvalidText(text:String) -> String{
        //uncaught exception 'InvalidPathValidation', reason: '(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']''
        var replaceText = text.replacingOccurrences(of: ".", with: "")
        replaceText = replaceText.replacingOccurrences(of: "#", with: "")
        replaceText = replaceText.replacingOccurrences(of: "[", with: "")
        replaceText = replaceText.replacingOccurrences(of: "]", with: "")
        replaceText = replaceText.replacingOccurrences(of: "$", with: "")
        return replaceText
    }
    // シェアするユーザーをホストのメンバーに追加
    func entryShareUser(shareUid:String){
        userDefaultsManager.setShareUserId(shareUid)
        let id = userDefaultsManager.getUserId()
        let name = userDefaultsManager.getUserName()
        let shareName = userDefaultsManager.getShareUserName()
        
        // Host名とメンバー名を一括更新
        var entryItems:[String:String] = [:]
        entryItems.updateValue(shareName, forKey: "\(id)/shareHost/\(shareUid)") // Host名
        entryItems.updateValue(name, forKey: "\(shareUid)/member/\(id)")         // メンバー名
        ref.child("users").updateChildValues(entryItems)
    }
    
    // ShareDataView > OtherShareUserIdView > 解除ボタン用
    // シェアユーザーを[自身のshareHost]と[ホストのmember]から削除
    func removeShareUser(){
        let id = userDefaultsManager.getUserId()
        let shareUid = userDefaultsManager.getShareUserId()
        
        var removeItems:[String:Any?] = [:]
        removeItems.updateValue(nil, forKey: "\(id)/shareHost/\(shareUid)")
        removeItems.updateValue(nil, forKey: "\(shareUid)/member/\(id)")
        ref.child("users").updateChildValues(removeItems as [AnyHashable : Any] )
        
        // MARK: UserDefaults リセット
        userDefaultsManager.setShareUserId("unknown")
        userDefaultsManager.setShareUserName("unknown")
    }
    // 強制メンバー解除
    func ForcedReleaseMember(){
        // MemberのHostを削除
        var removeItems:[String:Any?] = [:]
        for (m_id,_) in self.memberDic{
            removeItems.updateValue(nil, forKey: "\(m_id)/shareHost")
        }
        // 自身のMemberを削除
        removeItems.updateValue(nil, forKey: "\(userDefaultsManager.getUserId())/member")
        // 実行
        ref.child("users").updateChildValues(removeItems as [AnyHashable : Any] )
    }
    // MARK: - 4.Share
    

    

    // MARK: - 5.Fetch Data
    // ネット接続状況によって処理を分岐させる
    func checkConnectedCallLoading(){
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                //  Connected
                self.loadingData()
            } else {
                //  Not connected
                self.localLoadingData()
            }
        })
    }
    
    // オンライン時のデータ読み込み
    func loadingData() {
        self.initDic()
        ref.child("users").child(currentUserID).getData(completion:  { error, snapshot in
            guard error == nil || snapshot != nil else {
                return
            }
            self.setSnapShot(snapshot!)
            self.observeData()
        })
    }
    
    // オフライン時のキャッシュデータ読み込み
    private func localLoadingData(){
        self.initDic()
        ref.child("users").child(currentUserID).observeSingleEvent(of: .value, with: { snapshot in
            self.setSnapShot(snapshot)
        })
    }
    
    // データベース観測開始
    private func observeData() {
        ref.child("users").child(currentUserID).observe(.value) { snapshot in
            self.setSnapShot(snapshot)
        }
    }
    
    // データセット
    private func setSnapShot(_ snapshot:DataSnapshot){
        self.initDic()
        if let data = snapshot.value as? [String:AnyObject]{
            
            // MARK: シェアメンバー格納表示用
            if let memberDic = data["member"] as? Dictionary<String, String> {
                self.memberDic = memberDic
            }
            
            // MARK: シェアホストセット用
            // ログアウトしていないならUserDefaultsにシェア情報が格納ずみだが
            // ログアウトからメンバーがログイン時にシェアホストチェック → currentUserIdが変化しHostのデータが表示されるようになる
            if let shareDic = data["shareHost"] as? Dictionary<String, String> {
                self.userDefaultsManager.setShareUserId(shareDic.keys.first!)
                self.userDefaultsManager.setShareUserName(shareDic.values.first!)
            }else{
                // shareHostが存在しない かつ　誰にも共有していない
                if userDefaultsManager.getShareUserId() != "unknown" && self.memberDic.count == 0 {
                    // シェアHost削除後にUserDefaultsに残っている値を明示的に上書き : Hostから強制解放や退会されている可能性
                    self.userDefaultsManager.setShareUserId("unknown")
                    self.userDefaultsManager.setShareUserName("unknown")
                    checkConnectedCallLoading()
                }
            }
            
            // MARK: 買い物リストデータ
            if let userDic = data["group"] as? Dictionary<String, Any> {
                for (key,dic) in userDic{
                    let groupDic = dic as? Dictionary<String, Any>
                    let name = groupDic?["name"]! as? String
                    var array:[ShoppingItem] = []
                    if let list = groupDic?["list"]  as? Dictionary<String, Any> {
                        for (key,dic) in list {
                            if let itemDic = dic as? Dictionary<String,Any> {
                                let name = itemDic["name"]!
                                let shopped = itemDic["shopped"] ?? true
                                let obj = ShoppingItem(id:key, name: name as! String,shopped: shopped as! Bool)
                                array.append(obj)
                            }
                        }
                    }
                    
                    let obj = ShoppingGroup(id: key, name: name!,list: array)
                    self.groupArray.append(obj)
                }
            }
            // MARK: 買い物リストデータ
            
            // MARK: メニュー格納
            if let menuDic = data["menu"] as? Dictionary<String, Any> {
                if let week = menuDic["week"]  as? Array<String> {
                    menuObj.week = week
                }
                if let memo = menuDic["memo"]  as? String {
                    menuObj.memo = memo
                }
            }
            
        }
    }
    // MARK: - 5.Fetch Data
    
    // MARK: - 6.Menu
    func updateMenu(menuArray:[String],memo:String){
        var updateItems:[String:Any?] = [:]
        updateItems.updateValue(menuArray, forKey: "week")
        updateItems.updateValue(memo, forKey: "memo")
        menuRef.updateChildValues(updateItems as [AnyHashable : Any] )
    }
    
    // MARK: - 6.Menu
}
