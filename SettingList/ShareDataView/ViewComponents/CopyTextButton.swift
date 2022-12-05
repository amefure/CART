//
//  CopyTextButton.swift
//  CART
//
//  Created by t&a on 2022/11/23.
//

import SwiftUI


// MARK: - ShareDataView

struct CopyTextButton: View {
    
    @ObservedObject  var messageAlert = MessageBalloon()
    
    var text:String
    var body: some View {
        ZStack {
            if (messageAlert.isPreview){
                Text("コピーしました")
                    .font(.system(size: 8))
                    .padding(3)
                    .background(Color(red: 0.3, green: 0.3 ,blue: 0.3))
                    .foregroundColor(.white)
                    .opacity(messageAlert.castOpacity())
                    .cornerRadius(5)
                    .offset(x: -5, y: -20)
            }
            
            Button(action: {
                UIPasteboard.general.string = text
                messageAlert.isPreview = true
                messageAlert.vanishMessage()
                
            }, label: {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.gray)
                    .frame(width: 65)
            }).disabled(messageAlert.isPreview)
            
        } // ZStack
    }
}

// コピーしました用のメッセージバルーン
class MessageBalloon:ObservableObject{
    
    // opacityモディファイアの引数に使用
    @Published  var opacity:Double = 10.0
    // 表示/非表示を切り替える用
    @Published  var isPreview:Bool = false
    
    private var timer = Timer()
    
    // Double型にキャスト＆opacityモディファイア用の数値に割り算
    func castOpacity() -> Double{
        Double(self.opacity / 10)
    }
    
    // opacityを徐々に減らすことでアニメーションを実装
    func vanishMessage(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
            self.opacity = self.opacity - 1.0 // デクリメント
            
            if(self.opacity == 0.0){
                self.isPreview = false  // 非表示
                self.opacity = 10.0     // 初期値リセット
                self.timer.invalidate() // タイマーストップ
            }
        }
    }
    
}



