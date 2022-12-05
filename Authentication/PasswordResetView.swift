//
//  PasswordResetView.swift
//  CART
//
//  Created by t&a on 2022/11/17.
//

import SwiftUI
import FirebaseAuth

struct PasswordResetView: View {
    
    // MARK: - インスタンス
    @ObservedObject var authManager = AuthManager.shared
    var validationManager = ValidationManager()
    
    // MARK: - Inputプロパティ
    @State var email:String = ""
        
    var body: some View {
        VStack{
            
            TextField("メールアドレス", text: $email).padding().textFieldStyle(.roundedBorder)
            Button(action: {
                if validationManager.validateEmail(email: email) {
                    authManager.resetPassWord(email: email) { result in
                        if result {
                            
                        }
                    }
                }
            }, label: {
                Text("メール送信")
            })
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
