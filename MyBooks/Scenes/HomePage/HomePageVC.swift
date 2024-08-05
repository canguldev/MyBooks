//
//  HomePageVC.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//

import UIKit

class HomePageVC: UIViewController {
    //MARK: - Variables
    @IBOutlet weak var booksTableView: UITableView!
    var books = [Book]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBooks()
    }
    
    //MARK: - Helper Functions
    func fetchBooks() {
        do {
            self.books = try context.fetch(Book.fetchRequest())
            DispatchQueue.main.async {
                self.booksTableView.reloadData()
            }
        } catch {
            customErrorAlert(message: "Data couldn't be fetched. Please try again.")
        }
    }
    
    private func deleteBook(selectedBook: Book) {
        context.delete(selectedBook)
        do {
            try context.save()
        } catch {
            customErrorAlert(message: "Data couldn't be deleted. Please try again")
        }
        fetchBooks()
    }
}

//MARK: - UITableViewDelegate
extension HomePageVC: UITextViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentBook = self.books[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.deleteBook(selectedBook: currentBook)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit last read page") { _, _, _ in
            self.editLastReadPageAlert(currentBook: currentBook, forRowAt: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

//MARK: - UITableViewDataSource
extension HomePageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = booksTableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BooksTableViewCell
        if !books.isEmpty {
            let book = self.books[indexPath.row]
            if let bookName = book.title, let lastPage = book.lastReadPage, let bookPage = book.pages {
                cell.bookNameLabel.text = bookName
                cell.bookPageLabel.text = "\(lastPage)/\(bookPage)"
            }
        } else {
            booksTableView.isHidden = true
        }
        return cell
    }
}

//MARK: - Edit last read page alert extension
extension HomePageVC {
    func editLastReadPageAlert(currentBook: Book, forRowAt indexPath: IndexPath) {
        let lastReadPageAlert = UIAlertController(title: "Edit Last Read Page", message: nil, preferredStyle: .alert)
        lastReadPageAlert.addTextField()

        let alertTextField = lastReadPageAlert.textFields![0]
        alertTextField.keyboardType = .numberPad
        alertTextField.text = currentBook.lastReadPage
        if alertTextField.text == "0" {
            alertTextField.text = ""
        }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            if let currentPageNumber = Int(currentBook.pages!), let editPageNumber = Int(alertTextField.text!) {
                if (editPageNumber > currentPageNumber) {
                    self.customErrorAlert(message: "The number of pages cannot exceed the total number of pages in the book!")
                } else {
                    currentBook.lastReadPage = alertTextField.text
                    do {
                        try self.context.save()
                    } catch {
                        self.customErrorAlert(message: "Data couldn't be saved. Please try again.")
                    }
                    self.booksTableView.reloadData()
                }
            }
        }
        lastReadPageAlert.addAction(saveButton)
        present(lastReadPageAlert, animated: true)
    }
}
