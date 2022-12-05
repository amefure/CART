//
//  ValidationManager.swift
//  CART
//
//  Created by t&a on 2022/11/18.
//

import SwiftUI

// MARK: - 入力値バリデーション管理クラス
class ValidationManager {
    
    // MARK: - Empty
    func validateEmpty(str: String) -> Bool {
        if str != ""{
            return true
        }
        return false
    }
    
    // MARK: - Email
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
  
    // MARK: - PassWord
    func validatePassWord(password: String) -> Bool {
        if password.count >= 8 {
            return true
        }
        return false
    }
}
