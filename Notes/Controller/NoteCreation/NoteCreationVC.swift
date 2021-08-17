//
//  NoteCreationVC.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import UIKit

class NoteCreationVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnPin: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tblOutlet: UITableView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var layoutImage: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    var imagee = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
  
    func initialSetup() {
        imageViewOutlet.image = nil
        
        if imageViewOutlet.image == nil {
            imageViewOutlet.isHidden = true
//            ImgVwPlaceHolder.isHidden = false
            layoutImage.constant = 0
            btnPin.backgroundColor = #colorLiteral(red: 0.1097887084, green: 0.1098116413, blue: 0.1097855791, alpha: 1)
        } else {
            imageViewOutlet.isHidden = false
//            ImgVwPlaceHolder.isHidden = true
            layoutImage.constant = 150
            btnPin.backgroundColor = .green
        }
        
        
        btnBack.layer.cornerRadius = 15
        btnBack.clipsToBounds = true
        
        btnPin.layer.cornerRadius = 15
        btnPin.clipsToBounds = true
        btnPin.backgroundColor = #colorLiteral(red: 0.1097887084, green: 0.1098116413, blue: 0.1097855791, alpha: 1)
        
        btnSave.layer.cornerRadius = 15
        btnSave.clipsToBounds = true
        
        tblOutlet.delegate = self
        tblOutlet.dataSource = self
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapPin(_ sender: UIButton) {
        self.view.endEditing(true)
        let actionSheet = UIAlertController(title: "Profile Photo", message: "Option to select", preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (obj) in
            print("Cancel")
        }
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (obj) in
            print("Camera Button")
            
            if(UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                //            self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .front
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let actionController: UIAlertController = UIAlertController(title: "Camera is not available",message: "Please check this on an iPhone device", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void  in
                    //Just dismiss the action sheet
                }
                actionController.addAction(cancelAction)
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
                    if let currentPopoverpresentioncontroller = actionController.popoverPresentationController{
                        currentPopoverpresentioncontroller.sourceView = sender
                        currentPopoverpresentioncontroller.sourceRect = sender.bounds;
                        currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.down;
                        self.present(actionController, animated: true, completion: nil)
                        
                    }
                }else{
                    self.present(actionController, animated: true, completion: nil)
                    
                }
            }
            
        }
        
        let GalleryButton = UIAlertAction(title: "Gallery", style: .default) { (obj) in
            print("Gallery Button")
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let removePhoto = UIAlertAction(title: "Remove Photo", style: .default) { (obj) in
            print("Remove Button")
//            self.imageViewOutlet.image = #imageLiteral(resourceName: "placeholder")
            self.layoutImage.constant = 0
            self.btnPin.backgroundColor = #colorLiteral(red: 0.1097887084, green: 0.1098116413, blue: 0.1097855791, alpha: 1)
        }
        
        if imageViewOutlet.image == nil {
            // Do Nothing
        } else {
            actionSheet.addAction(removePhoto)
        }
        
        actionSheet.addAction(cancelButton)
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(GalleryButton)
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let currentPopoverpresentioncontroller = actionSheet.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = sender
                currentPopoverpresentioncontroller.sourceRect = sender.bounds;
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.down;
                self.present(actionSheet, animated: true, completion: nil)
            }
        } else {
            self.present(actionSheet, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Your note has been saved", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (obj) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteHomeVC") as! NoteHomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}

extension NoteCreationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCreationTitleCell", for: indexPath) as! NoteCreationTitleCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCreationContentCell", for: indexPath) as! NoteCreationContentCell
            cell.delegate = self
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
}

extension NoteCreationVC: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
    }
}

//MARK: - Tool Bar change Batter and Time color --------------------------
extension NoteCreationVC {
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
}

extension NoteCreationVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// Image Picker
extension NoteCreationVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate{
    
    //Mark:- Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imageViewOutlet.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagee = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        
        if imageViewOutlet.image == nil {
            imageViewOutlet.isHidden = true
//            ImgVwPlaceHolder.isHidden = false
            layoutImage.constant = 0
            btnPin.backgroundColor = #colorLiteral(red: 0.1097887084, green: 0.1098116413, blue: 0.1097855791, alpha: 1)
        } else {
            imageViewOutlet.isHidden = false
//            ImgVwPlaceHolder.isHidden = true
            layoutImage.constant = 150
            btnPin.backgroundColor = .green
        }
        
    }
    
}

extension NoteCreationVC: ExpandingTableViewTitleCellDelegate {
    // Expanding teable view cell delegate
    func didChangeText(text: String?, cell: NoteCreationTitleCell) {
        tblOutlet.beginUpdates()
        tblOutlet.endUpdates()
    }
}

extension NoteCreationVC: ExpandingTableViewCellContentDelegate {
    // Expanding teable view cell delegate
    func didChangeText(text: String?, cell: NoteCreationContentCell) {
        tblOutlet.beginUpdates()
        tblOutlet.endUpdates()
    }
}

@IBDesignable class ZeroPaddingTextView: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
    
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
}
