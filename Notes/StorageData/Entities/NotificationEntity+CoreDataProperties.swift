//
//  NotificationEntity+CoreDataProperties.swift
//  Notes
//
//  Created by Balamurugan on 17/08/21.
//  Copyright © 2021 . All rights reserved.
//
//

import Foundation
import CoreData

extension NotificationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationEntity> {
        return NSFetchRequest<NotificationEntity>(entityName: "NotificationEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var image: String?
    @NSManaged public var body: String
    @NSManaged public var title: String
    @NSManaged public var time: String

}
