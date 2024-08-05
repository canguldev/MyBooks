//
//  CustomAlertView.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//

import UIKit

extension UIViewController {
    //MARK: - Configure Custom Element
    func customDeleteAlertView(completion: (() -> Void)? = nil) {
        let deleteAlert = UIAlertController(title: "Delete book!", message: "Are you sure you want to delete this book? This action cannot be undone.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion?()
        }
        deleteAlert.addAction(cancelButton)
        deleteAlert.addAction(deleteButton)
        present(deleteAlert, animated: true)
    }
    
    func customErrorAlertView(message: String) {
        let errorAlert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        errorAlert.addAction(okayButton)
        present(errorAlert, animated: true)
    }
}
