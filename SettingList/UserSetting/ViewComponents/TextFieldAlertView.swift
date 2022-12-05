//
//  TextFieldAlertView.swift
//  CART
//
//  Created by t&a on 2022/11/26.
//

// MARK: - reference
// Alertの中にTextFieldを組み込む　UIKit×Swift UI

// MARK: - reference

// UserSetting > EditUserInofoView
// UserSetting > UserWithDrawalView

import SwiftUI

struct TextFieldAlertView: UIViewControllerRepresentable {
    
    // MARK: - Binding
    @Binding var isActive: Bool // 追加
    
    @Binding var text: String
    @Binding var isShowingAlert: Bool
    
    // MARK: - プロパティ
    let placeholder: String
    let isSecureTextEntry: Bool
    let title: String
    let message: String
    
    // MARK: - ボタンタイトル
    let leftButtonTitle: String?
    let rightButtonTitle: String?
    
    // MARK: - ボタンアクション
    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlertView>) -> some UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldAlertView>) {
        
        guard context.coordinator.alert == nil else {
            return
        }
        
        if !isShowingAlert {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        context.coordinator.alert = alert
        
        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
            textField.delegate = context.coordinator
            textField.isSecureTextEntry = isSecureTextEntry
        }
        

        
        if leftButtonTitle != nil {
            alert.addAction(UIAlertAction(title: leftButtonTitle, style: .default) { _ in
                alert.dismiss(animated: true) {
                    isShowingAlert = false
                    leftButtonAction?()
                }
            })
        }
        
        if rightButtonTitle != nil {
            alert.addAction(UIAlertAction(title: rightButtonTitle, style: .default) { _ in
                if let textField = alert.textFields?.first, let text = textField.text {
                    self.text = text
                }
                rightButtonAction?()
                alert.dismiss(animated: true) {
                    isShowingAlert = false
                }
            })
        }
        
        DispatchQueue.main.async {
            uiViewController.present(alert, animated: true, completion: {
                isShowingAlert = false
                context.coordinator.alert = nil
            })
        }
    }
    
    func makeCoordinator() -> TextFieldAlertView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var alert: UIAlertController?
        var view: TextFieldAlertView
        
        init(_ view: TextFieldAlertView) {
            self.view = view
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.view.text = text.replacingCharacters(in: range, with: string)
            } else {
                self.view.text = ""
            }
            return true
        }
    }
}
