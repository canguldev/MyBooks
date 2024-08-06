//
//  EditPageVC.swift
//  MyBooks
//
//  Created by Can Gül on 6.08.2024.
//

import UIKit
import CoreData

class EditPageVC: UIViewController {
    //MARK: - Variables
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pageCountTextField: UITextField!
    var currentBook: Book?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentBook()
        registerForKeyboardNotifications()
        assignTagsToTextFields()
    }
    
    private func assignmentBook() {
        if let book = currentBook {
            authorTextField.text = book.author
            titleTextField.text = book.title
            pageCountTextField.text = book.pages
        }
    }
    
    //MARK: - Helper Functions
    private func editBook() {
        if let authorName = authorTextField.text, let bookTitle = titleTextField.text, let bookPage = pageCountTextField.text {
            if !authorName.isEmpty, !bookTitle.isEmpty, !bookPage.isEmpty {
                if let book = currentBook {
                    book.author = authorName
                    book.title = bookTitle
                    book.pages = bookPage
                    do {
                        try self.context.save()
                    } catch {
                        customErrorAlertView(message: "Data couldn't be saved. Please try again.")
                    }
                    navigationController?.popToRootViewController(animated: true)
                }
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
        editBook()
    }
}
