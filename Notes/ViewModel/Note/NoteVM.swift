//
//  NoteVM.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import Foundation


// MARK: - Login
protocol DelegateLogin: AnyObject {
    func successLoginObj(resObj: [LoginModelElement])
    func errorLoginObj(strError: String)
}


class VMLogin {
    
    static weak var delegateLogin: DelegateLogin?
    
    //MARK:- Login
    
    static func getLoginDetails() {
        
        getttWebService(str_methodName: EnumMethodName.API_Login.rawValue) { resultObj in
                    
            do{
                let data_ = try JSONSerialization.data(withJSONObject:resultObj , options: .prettyPrinted)
                let loginObj = try? JSONDecoder().decode([LoginModelElement].self, from: data_)
                
                guard loginObj != nil else {
                    delegateLogin?.errorLoginObj(strError: EnumAlertMessage.jsonError.rawValue)
                    return
                }
                                
                DispatchQueue.main.async {
                    delegateLogin?.successLoginObj(resObj: loginObj!)
                }
                
            }catch(let err_){
                
                let data_err = try? JSONSerialization.data(withJSONObject:resultObj , options: .prettyPrinted)
                
                guard (data_err != nil) else {
                    delegateLogin?.errorLoginObj(strError: err_.localizedDescription)
                    return
                }
                
            }
            
        }
    }
}





// Common Error Message for API

// MARK: - APILoginErrorObj
struct APILoginErrorObj: Codable {
    var statusCode: Int?
    var error, message, responseType: String?
}









