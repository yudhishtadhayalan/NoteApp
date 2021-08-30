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
    var hyperLink_Slicing : String?
    var answer: NSAttributedString?

    
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
    
    func attributedText(boldString : String,urltext : String) -> NSAttributedString {
        let item_ = modelNoteModelElement?[valuePassSelectedItem ?? 0]
        let apiString = item_?.body as NSString?
        let string = apiString ?? ""
        let url = URL(string: "\(hyperLink_Slicing ?? "https://www.zoho.com/index1.html")")
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0)])
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25.0)]

        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: boldString))
        attributedString.setAttributes([.link:url], range: string.range(of: urltext))
        attributedString.mutableString.replaceOccurrences(of: "**", with: "", options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(0, attributedString.mutableString.length));
        attributedString.mutableString.replaceOccurrences(of: "\(hyperLink_Slicing ?? "")", with: "", options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(0, attributedString.mutableString.length));
        attributedString.mutableString.replaceOccurrences(of: "[", with: "", options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(0, attributedString.mutableString.length));
        attributedString.mutableString.replaceOccurrences(of: "]", with: "", options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(0, attributedString.mutableString.length));
        attributedString.mutableString.replaceOccurrences(of: "(", with: "", options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(0, attributedString.mutableString.length));
        attributedString.mutableString.replaceOccurrences(of: ")", with: "", options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(0, attributedString.mutableString.length));

        return attributedString
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
            let item_ = modelNoteModelElement?[valuePassSelectedItem ?? 0]
            let apiString = item_?.body as NSString?
            //MARK: ---- Slicing ----------
            let bold_Slicing = "\(apiString ?? "")".slice(from: "**", to: "**")
            hyperLink_Slicing = "\(apiString ?? "")".slice(from: "(", to: ")")
            let contentClickHere_or_ReadThis = "\(apiString ?? "")".slice(from: "[", to: "]")
            answer = attributedText(boldString: bold_Slicing ?? "", urltext: "\(contentClickHere_or_ReadThis ?? "")" )
            contentCell.textView.attributedText = answer//text = item_?.body
            contentCell.textView.isEditable = false
//            contentCell.textView.dataDetectorTypes = .link
            contentCell.textView.textColor = UIColor.white
            contentCell.textView.backgroundColor = UIColor.clear
            

            
            return contentCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else {
            return 500//UITableView.automaticDimension
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








extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
}
