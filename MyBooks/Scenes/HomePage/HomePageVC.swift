//
//  HomePageVC.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//

import UIKit
import CoreData

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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Helper Functions
    func fetchBooks() {
        do {
            self.books = try context.fetch(Book.fetchRequest())
            DispatchQueue.main.async {
                self.booksTableView.reloadData()
            }
        } catch {
            customErrorAlertView(message: "Data couldn't be fetched. Please try again.")
        }
    }
    
    private func deleteBook(selectedBook: Book) {
        context.delete(selectedBook)
        do {
            try context.save()
        } catch {
            customErrorAlertView(message: "Data couldn't be deleted. Please try again")
        }
        fetchBooks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToDetailPage" {
            let destinationVC = segue.destination as! DetailPageVC
            destinationVC.currentBook = books[sender as! Int]
        }
    }
}

//MARK: - UITableViewDelegate
extension HomePageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "homeToDetailPage", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentBook = self.books[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.customDeleteAlertView {
                self.deleteBook(selectedBook: currentBook)
            }
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
        return books.count
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
                    self.customErrorAlertView(message: "The number of pages cannot exceed the total number of pages in the book!")
                } else {
                    currentBook.lastReadPage = alertTextField.text
                    do {
                        try self.context.save()
                    } catch {
                        self.customErrorAlertView(message: "Data couldn't be saved. Please try again.")
                    }
                    self.booksTableView.reloadData()
                }
            }
        }
        lastReadPageAlert.addAction(saveButton)
        present(lastReadPageAlert, animated: true)
    }
}
