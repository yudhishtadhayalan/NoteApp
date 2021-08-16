//
//  HomeModel.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import Foundation

//// MARK: - LoginModel
//struct LoginModel: Codable {
//    var data: DataClass?
//    var message, status: String?
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    var email, password, firstname, lastname: String?
//    var contactno: String?
//}



// MARK: - LoginModel
struct LoginModelElement: Codable {
    var id, title, body, time: String?
    var image: String?
}

typealias LoginModel = [LoginModelElement]
