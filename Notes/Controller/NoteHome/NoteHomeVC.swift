//
//  NoteHomeVC.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import UIKit

class NoteHomeVC: UIViewController {
    
    @IBOutlet weak var collectionVwNotes: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var arrayColor = [#colorLiteral(red: 1, green: 0.6369444728, blue: 0.5204316378, alpha: 1), #colorLiteral(red: 1, green: 0.7903530002, blue: 0.3777176142, alpha: 1), #colorLiteral(red: 0.8730370402, green: 0.9477366805, blue: 0.5035483241, alpha: 1), #colorLiteral(red: 0, green: 0.8953368068, blue: 0.9356026649, alpha: 1), #colorLiteral(red: 0.9062253833, green: 0.5326938629, blue: 0.8899034858, alpha: 1), #colorLiteral(red: 1, green: 0.4979843497, blue: 0.7015436292, alpha: 1), #colorLiteral(red: 0.1904207468, green: 0.8199267983, blue: 0.7703630328, alpha: 1)]
    var arrayHeading = ["How to make your personal brand stand out outline", "How to make your personal brand stand out outline", "How to make your personal brand stand out outline", "How to make your personal brand stand out outline", "How to make your personal brand stand out outline", "How to make your personal brand stand out outline", "Okay I will"]
    var arrayDate = ["May 21, 2020", "May 21, 2020", "May 21, 2020", "May 21, 2020", "May 21, 2020", "May 21, 2020", "Sep 2020"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        apiCallLogin()
    }
    
    func initialSetup() {
        collectionVwNotes.dataSource = self
        collectionVwNotes.delegate = self
        collectionVwNotes.backgroundColor = #colorLiteral(red: 0.1450795829, green: 0.1451074481, blue: 0.1450757384, alpha: 1)
        bgView.backgroundColor = #colorLiteral(red: 0.1450795829, green: 0.1451074481, blue: 0.1450757384, alpha: 1)
        
        
        // Edit Button
        btnEdit.layer.cornerRadius = btnEdit.frame.width/2
        btnEdit.clipsToBounds = true
        
        lblTitle.text = "Notes"
    }
    
    func apiCallLogin() {
        VMLogin.delegateLogin = self
        VMLogin.getLoginDetails()
    }
    
    @IBAction func didTapFloatingBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteCreationVC") as! NoteCreationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension NoteHomeVC: UICollectionViewDataSource {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteHomeCollectionCell", for: indexPath) as! NoteHomeCollectionCell
        cell.lblHeading.text = arrayHeading[indexPath.item]
        cell.lblDate.text = arrayDate[indexPath.item]
        cell.viewBg.backgroundColor = arrayColor[indexPath.item]
        return cell
    }
        
}

extension NoteHomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NoteHomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 3 {
            return CGSize(width: self.collectionVwNotes.frame.size.width, height: 160)
        } else {
            let padding: CGFloat = 25
            let collectionCellSize = collectionVwNotes.frame.size.width - padding
            return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
        }
 
        
//        return CGSize(width:collectionVwNotes.frame.size.width, height: collectionVwNotes.frame.size.height)//100)

    }
  
    
}

//MARK: - Tool Bar change Batter and Time color --------------------------
extension NoteHomeVC {

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
}



//MARK: - API CALL --------------------------
extension NoteHomeVC: DelegateLogin {
    func successLoginObj(resObj: LoginModelElement) {
        print("Success: - \(resObj)")


    }
    
    func errorLoginObj(strError: String) {
        print("ErrLogin:- \(strError)")
    }
    
}


