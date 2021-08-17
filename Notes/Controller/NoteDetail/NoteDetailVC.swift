//
//  NoteDetailVC.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import UIKit

class NoteDetailVC: UIViewController {
    
    @IBOutlet weak var tblOutlet: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    
    var valuePassSelectedItem: Int?
    var modelNoteModelElement: [NoteModelElement]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        btnBack.layer.cornerRadius = 15
        btnBack.clipsToBounds = true
        
        tblOutlet.delegate = self
        tblOutlet.dataSource = self
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension NoteDetailVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item_ = modelNoteModelElement?[valuePassSelectedItem ?? 0]
        
        if indexPath.row == 0 {
                    
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailHeaderCell") as! NoteDetailHeaderCell
            headerCell.lblHeading.text = item_?.title
            headerCell.lblDate.text = item_?.time
            return headerCell
            
        } else {
            
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailTableCell") as! NoteDetailTableCell//tableView.dequeueReusableHeaderFooterView(withIdentifier: "NoteDetailHeaderCell") as! NoteDetailHeaderCell
            contentCell.lblContent.text = item_?.body
            return contentCell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
        
    }
    
}

//MARK: - Tool Bar change Batter and Time color --------------------------
extension NoteDetailVC {

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
}
