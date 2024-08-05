//
//  BooksTableViewCell.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    //MARK: - Variables
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookPageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
