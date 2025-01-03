//
//  GroupModel.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import Foundation
import FirebaseFirestore

struct GroupModel: Codable, Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let createdAt: Date
    var members: [String]

    var encoded: [String: Any] {
        get throws {
            try Firestore.Encoder().encode(self)
        }
    }
}

import Foundation

struct MemberModel: Codable, Identifiable {
    var id: String
    let name: String
    let joinedAt: Date

    var encoded: [String: Any] {
        get throws {
            try Firestore.Encoder().encode(self)
        }
    }
}
