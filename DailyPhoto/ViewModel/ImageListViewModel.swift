//
//  ImageListViewModel.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import Foundation
import Firebase

class ImageListViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchImages(uid: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let snapshot = try await FirebaseClient.db.collection("users").document(uid).collection("images").getDocuments()
            self.images = try snapshot.documents.compactMap { document in
                try document.data(as: ImageModel.self)
            }
        } catch {
            errorMessage = "Failed to fetch images: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
