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
        
        if indexPath.row == 0 {
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailHeaderCell") as! NoteDetailHeaderCell
            headerCell.lblHeading.text = "Heading"
            return headerCell
            
        } else {
            
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailTableCell") as! NoteDetailTableCell//tableView.dequeueReusableHeaderFooterView(withIdentifier: "NoteDetailHeaderCell") as! NoteDetailHeaderCell
            contentCell.lblContent.text = "The foundation regularly organises gatherings (sathsangs) with Sadhguru in the Indian states of Tamil Nadu and Karnataka, where he delivers discourses, leads meditations, and conducts question-answer sessions.[14] It also organises annual pilgrimages (yatras) to Mount Kailash and the Himalayas. The Kailash pilgrimage led by Sadhguru is among the largest groups to visit Kailash, with 514 pilgrims making the journey in 2010.[15][16]"
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
