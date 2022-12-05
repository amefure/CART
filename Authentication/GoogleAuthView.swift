//
//  GoogleAuthView.swift
//  CART
//
//  Created by t&a on 2022/12/03.
//

import SwiftUI

struct GoogleAuthView: View {
    // MARK: - インスタンス
    var authManager = AuthManager.shared
    @Binding var isActive:Bool
    
    var body: some View {
        VStack{
            Button(action: {
                authManager.loginGoogleAuth { result in
                    if result {
                        isActive = true
                    }
                }
            }, label: {
                Text("GoogleアカウントでLogin")
            })
        }
    }
}


