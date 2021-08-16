//
//  Constant.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import Foundation

enum EnumBaseURLType: String {
    case Dev = "https://raw.githubusercontent.com"
    case Stage = "http://"
    case Live = "https://"
}

//GlobalVariables
let BaseURL = EnumBaseURLType.Dev.rawValue


//API Method Name
enum EnumMethodName: String {
    case API_Login = "/RishabhRaghunath/JustATest/master/posts"
}



//MARK:- Alert Message Description
enum EnumAlertMessage: String {
    case serverError = "No server response, please try again after some time"
    case Oops = "Oops!"
    case noInternetMsg = "Please check your internet connectivity and try again" //"Oops!!! No internet! Try again later"
    case Alert = "Alert"
    
    static var jsonError: EnumAlertMessage {
        get {
            return serverError
        }
    }
        
    static var tryAgainLater : EnumAlertMessage {
        get {
            return serverError
        }
    }
}

enum EnumKeys: String {
    case Badtoken = "Bad token"
}

enum EnumAPIKeys: String {
    case email = "email"
    case password = "password"
}

