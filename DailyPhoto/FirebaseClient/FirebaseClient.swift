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
    static func createGroup(group: GroupModel) async throws -> String {
        let groupRef = db.collection("groups").document(group.id)
        try await groupRef.setData(group.encoded)
        return group.id
    }

    static func addMemberToGroup(groupId: String, memberId: String) async throws {
        let groupRef = db.collection("groups").document(groupId)
        try await groupRef.updateData([
            "members": FieldValue.arrayUnion([memberId])
        ])
    }

    static func fetchGroup(groupId: String) async throws -> GroupModel {
        let groupRef = db.collection("groups").document(groupId)
        let document = try await groupRef.getDocument()

        guard let groupData = document.data() else {
            throw NSError(domain: "GroupFetchError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Group not found"])
        }

        return try Firestore.Decoder().decode(GroupModel.self, from: groupData)
    }
}
