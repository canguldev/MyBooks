//
//  CustomAlertView.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//

import UIKit

extension UIViewController {
    //MARK: - Configure Custom Element
    func customErrorAlert(message: String) {
        let errorAlert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        errorAlert.addAction(okayButton)
        present(errorAlert, animated: true)
    }
}
