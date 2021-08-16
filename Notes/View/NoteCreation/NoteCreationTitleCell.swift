//
//  TextTableViewCell.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 15/08/21.
//

import UIKit

protocol ExpandingTableViewTitleCellDelegate: class {
    func didChangeText(text: String?, cell: NoteCreationTitleCell)
}


class NoteCreationTitleCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: ExpandingTableViewTitleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    
    func initialSetup() {
        textView.delegate = self
        textView.isEditable = true
        textView.text = "Title"
        textView.isScrollEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didChangeText(text: textView.text, cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
