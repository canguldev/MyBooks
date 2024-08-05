//
//  AddPageVC.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//

import UIKit

class AddPageVC: UIViewController {
    //MARK: - Variables
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pageCountTextField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        assignTagsToTextFields()
    }
    
    //MARK: - Helper Functions
    private func addBook() {
        if let author = authorTextField.text, let title = titleTextField.text, let pageCount = pageCountTextField.text {
            if !author.isEmpty, !title.isEmpty, !pageCount.isEmpty {
                let newBook = Book(context: self.context)
                newBook.author = author
                newBook.title = title
                newBook.pages = pageCount
                newBook.lastReadPage = "0"
                do {
                    try self.context.save()
                } catch {
                    customErrorAlertView(message: "Data couldn't be saved. Please try again.")
                }
                navigationController?.popViewController(animated: true)
            } else {
                customErrorAlertView(message: "Data couldn't be saved due to empty fields. Please complete the fields and try again.")
            }
        }
    }
    
    private func assignTagsToTextFields() {
        authorTextField.tag = 1
        titleTextField.tag = 2
        pageCountTextField.tag = 3
    }
    
    //MARK: - @Actions
    @IBAction func saveButton(_ sender: Any) {
        addBook()
    }
}
