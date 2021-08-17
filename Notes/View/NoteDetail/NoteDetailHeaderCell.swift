//
//  NoteDetailHeaderCell.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 14/08/21.
//

import UIKit

class NoteDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
