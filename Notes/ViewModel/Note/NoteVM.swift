//
//  NoteVM.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import Foundation


// MARK: - Note
protocol DelegateNote: AnyObject {
    func successNoteObj(resObj: [NoteModelElement])
    func errorNoteObj(strError: String)
}


class VMNote {
    
    static weak var delegateNote: DelegateNote?
    
    //MARK:- Note
    
    static func getNoteDetails() {
        
        getttWebService(str_methodName: EnumMethodName.API_Note.rawValue) { resultObj in
                    
            do{
                let data_ = try JSONSerialization.data(withJSONObject:resultObj , options: .prettyPrinted)
                let NoteObj = try? JSONDecoder().decode([NoteModelElement].self, from: data_)
                
                guard NoteObj != nil else {
                    delegateNote?.errorNoteObj(strError: EnumAlertMessage.jsonError.rawValue)
                    return
                }
                                
                DispatchQueue.main.async {
                    delegateNote?.successNoteObj(resObj: NoteObj!)
                }
                
            }catch(let err_){
                
                let data_err = try? JSONSerialization.data(withJSONObject:resultObj , options: .prettyPrinted)
                
                guard (data_err != nil) else {
                    delegateNote?.errorNoteObj(strError: err_.localizedDescription)
                    return
                }
                
            }
            
        }
    }
}





// Common Error Message for API

// MARK: - APINoteErrorObj
struct APINoteErrorObj: Codable {
    var statusCode: Int?
    var error, message, responseType: String?
}









