//
//  FirebaseClient.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import Foundation
import Firebase

enum FirebaseClientFirestoreError: Error {
    case roomModelNotFound
    case commentSubmissionFailed
}

enum FirebaseClient {
    static let db = Firestore.firestore()

    static func settingProfile(data: ProfileModel, uid: String) async throws {
        try await db.collection("users").document(uid).setData(data.encoded)
    }

    static func getProfileData(uid: String) async throws -> ProfileModel {
        let document = try await db.collection("users").document(uid).getDocument()
        return try document.data(as: ProfileModel.self)
    }
}
