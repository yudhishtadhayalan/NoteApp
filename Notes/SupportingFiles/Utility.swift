//
//  Utility.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import Foundation
import UIKit

class Utility {
    
    //MARK:- Custome Alert Views
    class func showAlert(str_title: String, str_msg: String, alertType: Int, completion: @escaping (Bool) -> Void){
        let alert = UIAlertController(title: str_title, message: str_msg, preferredStyle: .alert)
        let action_ok = UIAlertAction(title: "OK", style: .default) { (alert_) in
            
            DispatchQueue.main.async {
                completion(true)
            }
            
        }
        
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            completion(false)
        }
        if (alertType == 0) {
            alert.addAction(action_ok)
        }else{
            alert.addAction(action_ok)
            alert.addAction(action_cancel)
            alert.preferredAction = action_ok
        }
        
        getRootVC().present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:-
    static func getRootVC() -> UIViewController {
        guard var topVC = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController else {
            return UIViewController()
        }

        while let  presentedVC = topVC.presentedViewController{
            topVC = presentedVC
        }
        
        return topVC
    }

    
    
    class func stopIndicator(vc: UIViewController){
        vc.view.subviews.forEach { views_ in
            if let view = vc.view.viewWithTag(102){
                view.removeFromSuperview()
            }
        }
    }


}

