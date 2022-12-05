//
//  ErrorMessageView.swift
//  CART
//
//  Created by t&a on 2022/11/20.
//

import SwiftUI

struct ErrorMessageView: View {
    
    // MARK: - インスタンス
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        if authManager.errMessage != "" {
            Text("・\(AuthManager.shared.errMessage)")
                .padding(5)
                .foregroundColor(.white)
                .background(Color(red: 1, green: 0, blue: 0, opacity: 0.5))
                .cornerRadius(5)
        }
    }
}

struct ErrorMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessageView()
    }
}
