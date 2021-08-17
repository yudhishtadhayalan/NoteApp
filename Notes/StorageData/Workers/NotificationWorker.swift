//
//  NotificationWorker.swift
//  Notes
//
//  Created by Balamurugan on 16.07.21.
//  Copyright © 2021 . All rights reserved.
//

import Foundation
import CoreData

struct NotificationWorker {
    typealias SaveParameters = (String, String, String, String)
    typealias NotificationUserInfoF = () -> [AnyHashable: Any]
    typealias NotificationUseValueF = (NotificationUserInfoF) -> SaveParameters?

    fileprivate func getNotificationEntity(_ context: NSManagedObjectContext,
                                           _ id: UUID,
                                           _ completion: (Result<NotificationEntity, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let fetchRequest = NSFetchRequest<NotificationEntity>(entityName: "NotificationEntity")
        fetchRequest.predicate = predicate

        do {
            guard let notification = try context.fetch(fetchRequest).first else {
                completion(.failure(DataError.internalError("Can not find entity with id: \(id.uuidString)")))

                return
            }

            return completion(.success(notification))
        } catch {
            completion(.failure(error))
        }
    }
}

extension NotificationWorker: PCreateData {
    /// Create NotificationEntity. Comes from protocol "PCreateData".
    /// Create entity happens in custom queue.
    /// - Parameters:
    ///   - parametersF: (() -> Any?)?. These parameters are:
    ///   () -> [AnyHashable: Any] - userInfo
    ///   (() -> [AnyHashable: Any]) -> (String, String, String, String)? - title: String, topic: String, message: String, imageURL: String.
    ///   Default values are empty strings.
    ///   - completion: ((Result<Any, Error>) -> Void)?. Optiona parameter.
    func create(_ parametersF: ParametersF?, _ completion: ((Result<Any, Error>) -> Void)?) {
        let asyncBlock = BlockOperation {
            guard let (userInfoF, paramsF) = parametersF?() as? (NotificationUserInfoF, NotificationUseValueF) else {
                DispatchQueue.main.async {
                    completion?(.failure(DataError.internalError("Incorrect data(parametersF)!!!")))
                }

                return
            }
            guard let (title, body, time, image) = paramsF(userInfoF) else {
                DispatchQueue.main.async {
                    completion?(.failure(DataError.internalError("Incorrect data(paramsF)!!!")))
                }

                return
            }

            let dataManager = CoreDataManager.shared
            dataManager.persistentContainer.performBackgroundTask { context in
                let notification = NotificationEntity(context: context)
                notification.id = ""
                notification.title = title
                notification.body = body
                notification.time = time
                notification.image = image
                do {
                    try dataManager.saveContext(context)
                    let id = notification.id
                    DispatchQueue.main.async {
                        completion?(.success(id))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(error))
                    }
                }
            }
        }
        CustomOperationQueue.shared.addBlock(asyncBlock)
    }
}

extension NotificationWorker: PGetData {
    /// Get all NotificationEntities. Comes from protocol "PGetData".
    /// Used background ManagedObjectContext in main thread, but execute NSAsynchronousFetchRequest.
    /// - Parameters:
    ///   - parametersF: (() -> Any?)?. Optional parameter. In this implementation is null.
    ///   - filterF: ((Any) -> Result<Any, Error>)?. Optional parameter. In this implementation is null.
    ///   - completion: (Result<Any, Error>) -> Void. Return function with tuple of values:
    ///   id: UUID,
    ///   title: String,
    ///   topic: String,
    ///   message: String,
    ///   receivedDate: Date
    func get(_ parametersF: ParametersF?,
             _ filterF: FilterF?,
             _ completion: @escaping (Result<Any, Error>) -> Void) {
        guard let topic = parametersF?() as? String else {
            completion(.failure(DataError.internalError("Incorrect parametersF!!!")))

            return
        }

        let dateSortDescriptor = NSSortDescriptor(key: "receivedDate", ascending: false)
        let predicate = NSPredicate(format: "topic == %@", argumentArray: [topic])
        let fetchRequest = NSFetchRequest<NotificationEntity>(entityName: "NotificationEntity")
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        fetchRequest.predicate = predicate

        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asyncFetchResult in
            let entityToNotificationF: (NotificationEntity, Calendar) -> NotificationModel = { entity, calendar in
                return NotificationModel(id: entity.id,
                                         title: entity.title,
                                         body: entity.body,
                                         time: entity.time,
                                         image: entity.image)
            }
            let calendar = Calendar.current
            let result = (asyncFetchResult.finalResult ?? []).map { entityToNotificationF($0, calendar) }
            let filteredResult = filterF?({ result }) ?? .success({ result })

            DispatchQueue.main.async {
                completion(filteredResult)
            }
        }

        do {
            try CoreDataManager.shared.mainBackgroundContext.execute(asynchronousFetchRequest)
        } catch {
            completion(.failure(error))
        }
    }
}

extension NotificationWorker: PDeleteData {
    /// Delete notification entity with uuid
    /// - Parameters:
    ///   - parametersF: (() -> Any?)? Should return value of type uuid
    ///   - completion: ((Result<Any?, Error>) -> Void)?. If we have success operation, should return nil.
    func delete(_ parametersF: ParametersF?, _ completion: ((Result<Any?, Error>) -> Void)?) {
        guard let id = parametersF?() as? UUID else {
            completion?(.failure(DataError.internalError("Incorrect parametersF!!!")))

            return
        }

        let asyncBlock = BlockOperation {
            let dataManager = CoreDataManager.shared
            dataManager.persistentContainer.performBackgroundTask { context in
                getNotificationEntity(context, id) { result in
                    switch result {
                    case .success(let notification):
                        do {
                            context.delete(notification)
                            try dataManager.saveContext(context)
                            DispatchQueue.main.async {
                                completion?(.success(nil))
                            }
                        } catch {
                            DispatchQueue.main.async {
                                completion?(.failure(error))
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion?(.failure(error))
                        }
                    }
                }
            }
        }
        CustomOperationQueue.shared.addBlock(asyncBlock)
    }
}

extension NotificationWorker: PUpdateData {
    /// Update "isRead" property
    /// - Parameters:
    ///   - parametersF: () -> Any?. Should return UUID and isRead
    ///   - completion: ((Result<Any?, Error>) -> Void)? Return error or nil if operation is successful.
    func update(_ parametersF: () -> Any?, _ completion: ((Result<Any?, Error>) -> Void)?) {
        guard let (id, isRead) = parametersF() as? (UUID, Bool) else {
            completion?(.failure(DataError.internalError("Incorrect parametersF!!!")))

            return
        }

        let asyncBlock = BlockOperation {
            let dataManager = CoreDataManager.shared
            dataManager.persistentContainer.performBackgroundTask { context in
                getNotificationEntity(context, id) { result in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion?(.failure(error))
                        }
                    case .success(let notification):
                        do {
                            try dataManager.saveContext(context)
                            DispatchQueue.main.async {
                                completion?(.success(nil))
                            }
                        } catch {
                            DispatchQueue.main.async {
                                completion?(.failure(error))
                            }
                        }
                    }
                }
            }
        }
        CustomOperationQueue.shared.addBlock(asyncBlock)
    }
}

struct NotificationsCountWorker {}
extension NotificationsCountWorker: PGetData {
    /// Get count of notifications, that not read yet.
    /// - Parameters:
    ///   - parametersF: () -> Any? - () -> (key, value). "Key" is the name of the property. "Value" is value of this property.
    ///   - filterF: (Any) -> Result<Any, Error>
    ///   - completion: ((Result<Any, Error>) -> Void)?
    func get(_ parametersF: ParametersF?, _ filterF: FilterF?, _ completion: @escaping (Result<Any, Error>) -> Void) {
        guard let (key, value, topic) = parametersF?() as? (String, Bool, String) else {
            completion(.failure(DataError.internalError("Incorrect data(parametersF)!!!")))
            return
        }

        let asyncBlock = BlockOperation {
            CoreDataManager.shared.persistentContainer.performBackgroundTask { context in
                let predicate = NSPredicate(format: "%K = %d AND topic == %@", argumentArray: [key, value, topic])
                let fetchRequest = NSFetchRequest<NotificationEntity>(entityName: "NotificationEntity")
                fetchRequest.predicate = predicate
                fetchRequest.resultType = .countResultType

                do {
                    let results = try context.count(for: fetchRequest)
                    let finalResult = filterF?(results) ?? .success(results)
                    DispatchQueue.main.async {
                        completion(finalResult)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        CustomOperationQueue.shared.addBlock(asyncBlock)
    }
}

struct ProcessNotificationData {
    /// Process the data from the notification.
    /// - Parameter userInfo: () -> [AnyHashable: Any]. Dictionary with userInfo.
    /// - Returns: (String, String, String, String)? - title: String, topic: String, message: String, imageURL: String.
    func processNotification(_ userInfoF: NotificationWorker.NotificationUserInfoF) -> NotificationWorker.SaveParameters? {
        let userInfo = userInfoF()
        guard let alert = (userInfo["aps"] as? [String: Any])?["alert"] as? [String: String] else {
            return nil
        }
        // In iOS topic is not coming with push notification(firebase push notifications).
        let topic = ""
        let title = alert["title"] ?? ""
        let message = alert["body"] ?? ""
        let imageURL = (userInfo["fcm_options"] as? [String: String])?["image"] ?? ""

        return (title, topic, message, imageURL)
    }

    /// Create data from notification userInfo
    /// - Parameters:
    ///   - userInfoF: () -> [AnyHashable: Any]
    ///   - processParametersF: (() -> [AnyHashable: Any]) -> (String, String, String, String)? - title: String, topic: String, message: String, imageURL: String.
    func fillInNotificationToDatabase(_ userInfoF: @escaping NotificationWorker.NotificationUserInfoF,
                                      _ processParametersF: @escaping NotificationWorker.NotificationUseValueF) {
        let paramsF = { (userInfoF, processParametersF) }
        let notificationWorker = NotificationWorker()
        DataBridge().createData(notificationWorker, paramsF) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("error")
            }
        }
    }
}
