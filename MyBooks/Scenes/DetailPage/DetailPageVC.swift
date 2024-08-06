//
//  DetailPageVC.swift
//  MyBooks
//
//  Created by Can Gül on 6.08.2024.
//

import UIKit

class DetailPageVC: UIViewController {
    //MARK: - Variables
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var lastReadPageLabel: UILabel!
    var currentBook: Book?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentBook()
    }
    
    //MARK: - Helper Functions
    private func assignmentBook() {
        if let book = currentBook {
            authorLabel.text = book.author
            titleLabel.text = book.title
            pageCountLabel.text = book.pages
            lastReadPageLabel.text = book.lastReadPage
        }
    }
    
    //MARK: - @Actions
    @IBAction func editButton(_ sender: Any) {
        
    }
    
}
