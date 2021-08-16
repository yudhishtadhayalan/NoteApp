//
//  NoteDetailTableCell.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 14/08/21.
//

import UIKit

class NoteDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var lblContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
