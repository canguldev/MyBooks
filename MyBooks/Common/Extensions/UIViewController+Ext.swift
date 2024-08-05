//
//  UIViewController+Ext.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    //MARK: - TextField helper function
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    //MARK: - Keyboard Notification
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addKeyboardDismissTapGesture()
    }
    
    //MARK: - Keyboard Visible
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset: UIEdgeInsets = self.view.window?.safeAreaInsets ?? UIEdgeInsets.zero
            contentInset.bottom = keyboardSize.height
            adjustViewForKeyboard(contentInset: contentInset, notification: notification)
        }
    }
    
    //MARK: - Keyboard Not Visible
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = self.view.window?.safeAreaInsets ?? UIEdgeInsets.zero
        adjustViewForKeyboard(contentInset: contentInset, notification: notification)
    }
    
    //MARK: - Setup Keyboard Height
    private func adjustViewForKeyboard(contentInset: UIEdgeInsets, notification: NSNotification) {
            UIView.animate(withDuration: 0.3) {
                self.additionalSafeAreaInsets.bottom = contentInset.bottom - 32
                self.view.layoutIfNeeded()
            }
    }
    
    //MARK: - Add Gesture
    private func addKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
