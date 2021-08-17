//
//  DataBridge.swift
//  Notes
//
//  Created by Balamurugan on 15.07.21.
//  Copyright © 2021 . All rights reserved.
//

import Foundation

typealias FilterF = (Any) -> Result<Any, Error>
typealias ParametersF = () -> Any?

enum DataError: Error {
    case internalError(String)
}

extension DataError: LocalizedError {
    /// We implement this property "errorDescription",
    /// because we want our error to return appropriate message in "localizedDescription".
    var errorDescription: String? {
        var result: String?
        switch self {
        case .internalError(let message):
            result = message
        }

        return result
    }
}

/// Protocol defining method/s for getting data.
/// "P" comes from protocol.
protocol PGetData {
    /// Get any kind of stored data(Entities).
    /// - Parameters:
    ///   - parametersF: (() -> Any?)?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///    for operations like: select, sorting and etcetera. This is optional parameter.
    ///   - filterF: ((Any) -> Result<Any, Error>)?. Additional filter or values converter, without changing any existing code.
    ///   This is optional parameter.
    ///   - completion: (Result<Any, Error>) -> Void. Return "Result" of data or error, connecting with this operation.
    ///   This is not optional parameter.
    func get(_ parametersF: ParametersF?,
             _ filterF: FilterF?,
             _ completion: @escaping (Result<Any, Error>) -> Void)
}

/// Protocol defining method/s for updating data.
/// "P" comes from protocol.
protocol PUpdateData {
    /// Update existing data(Entity or Entities).
    /// - Parameters:
    ///   - parametersF: () -> Any?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///   for operations like: select. This is not optional parameter.
    ///   - completion: ((Result<Any?, Error>) -> Void)?. Return "Result" of data or error, connecting with this operation.
    ///   This is optional parameter.
    func update(_ parametersF: ParametersF,
                _ completion: ((Result<Any?, Error>) -> Void)?)
}

/// Protocol defining method/s for deleting data.
/// "P" comes from protocol.
protocol PDeleteData {
    /// Delete data (Entity or Entities).
    /// - Parameters:
    ///   - parametersF: (() -> Any?)?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///   for operations like: select, sorting and etcetera. This is optional parameter.
    ///   - completion: ((Result<Any?, Error>) -> Void)?. Return "Result" of data or error, connecting with this operation.
    ///   This is optional parameter.
    func delete(_ parametersF: ParametersF?,
                _ completion: ((Result<Any?, Error>) -> Void)?)
}

/// Protocol defining method/s for creating data
/// "P" comes from protocol.
protocol PCreateData {
    /// Create data (Entity or Entities).
    /// - Parameters:
    ///   - parametersF: (() -> Any?)?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///   for operations like: select, sorting and etcetera. This is optional parameter.
    ///   - completion: ((Result<Any?, Error>) -> Void)?. Return "Result" of data or error, connecting with this operation.
    ///   This is optional parameter.
    func create(_ parametersF: ParametersF?,
                _ completion: ((Result<Any, Error>) -> Void)?)
}

/// Use this struct to communicate with data.
struct DataBridge {
    /// Get any kind of stored data(Entities).
    /// - Parameters:
    ///   - worker: "class" or "struct", that implement "PGetData".
    ///   - parametersF: (() -> Any?)?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///   for operations like: select, sorting and etcetera. This is optional parameter.
    ///   - filterF: ((Any) -> Result<Any, Error>)?. Additional filter or values converter, without changing any existing code.
    ///   This is optional parameter.
    ///   - completion: (Result<Any, Error>) -> Void. Return "Result" of data or error, connecting with this operation.
    ///   This is not optional parameter.
    func getData<T: PGetData>(_ worker: T,
                              _ parametersF: ParametersF?,
                              _ filterF: FilterF?,
                              _ completion: @escaping (Result<Any, Error>) -> Void) {
        worker.get(parametersF, filterF, completion)
    }

    /// Update existing data(Entity or Entities).
    /// - Parameters:
    ///   - worker: "class" or "struct", that implement "PUpdateData".
    ///   - parametersF: () -> Any?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///   for operations like: select. This is not optional parameter.
    ///   - completion: ((Result<Any?, Error>) -> Void)?. Return "Result" of data or error, connecting with this operation.
    ///   This is optional parameter.
    func updateData<T: PUpdateData>(_ worker: T,
                                    _ parametersF: ParametersF,
                                    _ completion: ((Result<Any?, Error>) -> Void)?) {
        worker.update(parametersF, completion)
    }

    /// Delete data (Entity or Entities).
    /// - Parameters:
    ///   - worker: "class" or "struct", that implement "PDeleteData".
    ///   - parametersF: (() -> Any?)?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///   for operations like: select, sorting and etcetera. This is optional parameter.
    ///   - completion: ((Result<Any?, Error>) -> Void)?. Return "Result" of data or error, connecting with this operation.
    ///   This is optional parameter.
    func deleteData<T: PDeleteData>(_ worker: T,
                                    _ parametersF: ParametersF?,
                                    _ completion: ((Result<Any?, Error>) -> Void)?) {
        worker.delete(parametersF, completion)
    }

    /// Create data (Entity or Entities).
    /// - Parameters:
    ///   - worker: "class" or "struct", that implement "PCreateData".
    ///   - parametersF: (() -> Any?)?. These parameters use in NSFetchRequest or NSAsynchronousFetchRequest,
    ///   for operations like: select, sorting and etcetera. This is optional parameter.
    ///   - completion: ((Result<Any?, Error>) -> Void)?. Return "Result" of data or error, connecting with this operation.
    ///   This is optional parameter.
    func createData<T: PCreateData>(_ worker: T,
                                    _ parametersF: ParametersF?,
                                    _ completion: ((Result<Any, Error>) -> Void)?) {
        worker.create(parametersF, completion)
    }
}
