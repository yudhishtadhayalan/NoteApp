//
//  NoteDetailVC.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import UIKit
import SDWebImage

class NoteDetailVC: UIViewController {
    
    @IBOutlet weak var tblOutlet: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var layout_ImageHeight: NSLayoutConstraint!
    
    var valuePassSelectedItem: Int?
    var modelNoteModelElement: [NoteModelElement]!
    var isHidden: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        btnBack.layer.cornerRadius = 15
        btnBack.clipsToBounds = true
        
        tblOutlet.delegate = self
        tblOutlet.dataSource = self
        
        let item_ = modelNoteModelElement?[valuePassSelectedItem ?? 0]
        
        imgView.sd_setImage(with: URL(string: "\(item_?.image ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeHolder"))
        
        if item_?.image == nil || item_?.image == "" {
            layout_ImageHeight.constant = 0
        } else {
            layout_ImageHeight.constant = 150
        }
        
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
            
            let timeFromAPI = Int64(item_?.time ?? "") ?? 0
            
            let convert_Milli_To_Date = Date(milliseconds: timeFromAPI)
            headerCell.lblDate.text = "\(convert_Milli_To_Date)"
            
            return headerCell
            
        } else {
            
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailTableCell") as! NoteDetailTableCell
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


//MARK: - Date ----------------------
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
