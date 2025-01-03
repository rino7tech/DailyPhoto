//
//  GroupViewModel.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import Foundation
import FirebaseFirestore

class GroupViewModel: ObservableObject {
    @Published var groupMembers: [ProfileModel] = []
    @Published var errorMessage: String = ""

    func fetchGroupMembers(groupId: String) {
        Task {
            do {
                let db = Firestore.firestore()
                let groupRef = db.collection("groups").document(groupId)
                let snapshot = try await groupRef.collection("members").getDocuments()

                let members = snapshot.documents.compactMap { doc -> ProfileModel? in
                    guard let name = doc.data()["name"] as? String,
                          let createdAtTimestamp = doc.data()["createdAt"] as? Timestamp else {
                        return nil
                    }
                    let createdAt = createdAtTimestamp.dateValue()
                    return ProfileModel(id: doc.documentID, name: name, createdAt: createdAt)
                }

                DispatchQueue.main.async {
                    self.groupMembers = members
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "メンバーの取得に失敗しました: \(error.localizedDescription)"
                }
            }
        }
    }
}
