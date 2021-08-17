//
//  CustomOperationQueue.swift
//  Notes
//
//  Created by Balamurugan on 14.07.21.
//  Copyright © 2021 . All rights reserved.
//

import Foundation

/// Custom queue with limited concurrent operation.
final class CustomOperationQueue {
    private let asyncCustomOperationQueue = OperationQueue()

    static let shared = CustomOperationQueue()

    private init() {
        asyncCustomOperationQueue.name = "com.wallet.MoreAsyncOperationQueue"
        asyncCustomOperationQueue.maxConcurrentOperationCount = 2
    }

    func addBlocks(_ operations: [BlockOperation], _ waitUntilFinished: Bool) {
        asyncCustomOperationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func addBlock(_ operation: BlockOperation) {
        asyncCustomOperationQueue.addOperation(operation)
    }
}
