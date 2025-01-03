//
//  ImageModel.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import Foundation
import FirebaseFirestore

struct ImageModel: Codable {
    let url: String
    let uploadedAt: Date

    var encoded: [String: Any] {
        get throws {
            try Firestore.Encoder().encode(self)
        }
    }
}