//
//  FirebaseClient.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import Foundation
import Firebase
import FirebaseStorage

enum FirebaseClientFirestoreError: Error {
    case roomModelNotFound
    case commentSubmissionFailed
}

enum FirebaseClient {
    static let db = Firestore.firestore()
    static let storage = Storage.storage()

    static func uploadImage(data: Data, uid: String) async throws -> String {
        let storageRef = storage.reference().child("users/\(uid)/images/\(UUID().uuidString).jpg")
        _ = try await storageRef.putDataAsync(data, metadata: nil)
        return try await storageRef.downloadURL().absoluteString
    }

    static func saveImage(data: ImageModel, uid: String) async throws {
        let documentRef = db.collection("users").document(uid).collection("images").document()
        try await documentRef.setData(data.encoded)
    }

    static func settingProfile(data: ProfileModel, uid: String) async throws {
        try await db.collection("users").document(uid).setData(data.encoded)
    }

    static func getProfileData(uid: String) async throws -> ProfileModel {
        let document = try await db.collection("users").document(uid).getDocument()
        return try document.data(as: ProfileModel.self)
    }
}
