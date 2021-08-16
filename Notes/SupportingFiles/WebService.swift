//
//  WebService.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import Foundation
var isPutWithBody = false


func getttWebService(str_methodName: String, callBack: @escaping([[String : Any]]) -> Void) {
    
    if(!Reachability.isConnectedToNetwork()){
        Utility.showAlert(str_title: EnumAlertMessage.Oops.rawValue, str_msg: EnumAlertMessage.noInternetMsg.rawValue, alertType: 0){_ in
            Utility.stopIndicator(vc: Utility.getRootVC())
        }
        return
    }
    
    let url_str = URL(string: BaseURL + str_methodName)
    
    print("url_str:- \(url_str!)")
    var request = URLRequest(url: url_str!)
    request.httpMethod = "GET"
    
    let  task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            DispatchQueue.main.sync {
                Utility.showAlert(str_title: "Alert", str_msg: (error?.localizedDescription)!, alertType: 0){_ in
                    Utility.stopIndicator(vc: Utility.getRootVC())
                }
            }
            return
        }
        
        guard let content = data else {
           // print("not returning data")
            /**/
            DispatchQueue.main.sync {
                Utility.showAlert(str_title: "Alert", str_msg: EnumAlertMessage.serverError.rawValue, alertType: 0){_ in
                    Utility.stopIndicator(vc: Utility.getRootVC())
                }
            }
            return
        }
        //
        guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers))  else { //[String: Any]
            DispatchQueue.main.sync {
                Utility.showAlert(str_title: "Alert", str_msg: EnumAlertMessage.serverError.rawValue, alertType: 0){_ in
                    Utility.stopIndicator(vc: Utility.getRootVC())
                }
            }
            return
        }
        print("json:- \(json)")
        DispatchQueue.main.sync {
            callBack(json as! [[String : Any]])
//            callBack(json as! [String : String])
//            callBack(json as! [String : String]) //as! [String : Any])
        }
    }
    task.resume()
    
}


//MARK:- Background Request

func postWebServiceWithBackground(str_methodName: String, str_postParam: [String: Any], callBack: @escaping([String: Any]) -> Void) {
    
    if(!Reachability.isConnectedToNetwork()){
        //Utility.showAlert(str_title: "Alert", str_msg: EnumAlertMessage.noInternetMsg.rawValue, alertType: 0){_ in
            Utility.stopIndicator(vc: Utility.getRootVC())
        //}
        return
    }
    
    let url_str = URL(string: BaseURL + str_methodName)
    
    //print("str_postParam_2:- \(str_postParam) \n url_str:- \(url_str!)")
    var request = URLRequest(url: url_str!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let jsonData = try? JSONSerialization.data(withJSONObject: str_postParam)
    request.httpBody = jsonData
    
    let sessConfi = URLSessionConfiguration.background(withIdentifier: "AppTermination")
    let urlSession_ = URLSession(configuration: sessConfi)
    //let  task = urlSession_.downloadTask(with: request)
    
    let  task = urlSession_.dataTask(with: request)
    task.resume()
    
}



extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

func convertFormField(named name: String, value: String, using boundary: String) -> String {
  var fieldString = "--\(boundary)\r\n"
  fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
  fieldString += "\r\n"
  fieldString += "\(value)\r\n"

  return fieldString
}

func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
  let data = NSMutableData()

  data.appendString("--\(boundary)\r\n")
  data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
  data.appendString("Content-Type: \(mimeType)\r\n\r\n")
  data.append(fileData)
  data.appendString("\r\n")

  return data as Data
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
