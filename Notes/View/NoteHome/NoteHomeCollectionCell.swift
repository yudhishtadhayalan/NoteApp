//
//  NoteHomeCollectionCell.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import UIKit

class NoteHomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        basicSetup()
    }
    
    func basicSetup() {
        viewBg.layer.cornerRadius = 10
        viewBg.clipsToBounds = true
    }
    
}


