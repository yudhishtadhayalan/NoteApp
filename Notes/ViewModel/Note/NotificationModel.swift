//
//  NotificationModel.swift
//  Notes
//
//  Created by Balamurugan on 17/08/21.
//

import Foundation

final class NotificationModel {
    let id: String
    let title: String
    let body: String
    let time: String?
    let image: String?

    init(id: String,
         title: String,
         body: String,
         time: String,
         image: String?) {
        self.id = id
        self.title = title
        self.body = body
        self.time = time
        self.image = image
    }
}
