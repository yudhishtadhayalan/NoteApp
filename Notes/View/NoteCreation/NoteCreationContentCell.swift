//
//  NoteCreationContentCell.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 15/08/21.
//

import UIKit

protocol ExpandingTableViewCellContentDelegate: class {
    func didChangeText(text: String?, cell: NoteCreationContentCell)
}

class NoteCreationContentCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textViewContent: UITextView!
    
    weak var delegate: ExpandingTableViewCellContentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewContent.delegate = self
        textViewContent.isEditable = true
        textViewContent.text = "Type something..."
        textViewContent.isScrollEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didChangeText(text: textView.text, cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
