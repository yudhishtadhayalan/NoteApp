//
//  HomeModel.swift
//  Notes
//
//  Created by Yudhishta Dhayalan on 30/07/21.
//

import Foundation

// MARK: - NoteModel
struct NoteModelElement: Codable {
    var id, title, body, time: String?
    var image: String?
}

typealias NoteModel = [NoteModelElement]
