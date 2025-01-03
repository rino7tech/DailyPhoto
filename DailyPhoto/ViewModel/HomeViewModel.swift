//
//  HomeViewModel.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var isSaving: Bool = false

    func saveImage(image: UIImage) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async {
                self.errorMessage = "ユーザーIDが見つかりません。"
            }
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            DispatchQueue.main.async {
                self.errorMessage = "画像データの変換に失敗しました。"
            }
            return
        }

        do {
            DispatchQueue.main.async {
                self.isSaving = true
            }
            let imageURL = try await FirebaseClient.uploadImage(data: imageData, uid: uid)

            let imageModel = ImageModel(url: imageURL, uploadedAt: Date())
            try await FirebaseClient.saveImage(data: imageModel, uid: uid)

            DispatchQueue.main.async {
                self.isSaving = false
                self.errorMessage = "画像を保存しました！"
            }
        } catch {
            DispatchQueue.main.async {
                self.isSaving = false
                self.errorMessage = "画像保存エラー: \(error.localizedDescription)"
            }
        }
    }
}
