//
//  QRCodeGeneratorView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI
import FirebaseAuth

struct QRCodeGeneratorView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var generatedGroupId: String?
    let groupName = "My Group"

    var body: some View {
        VStack(spacing: 20) {
            if let currentUID = authViewModel.currentUID {
                Text("QRコードを生成して共有してください")
                    .font(.headline)
                    .padding()

                let qrCodeContent = generatedGroupId ?? currentUID

                if let qrImage = generateQRCode(from: qrCodeContent) {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                } else {
                    Text("QRコードの生成に失敗しました")
                        .foregroundColor(.red)
                }

                if generatedGroupId == nil {
                    Button(action: {
                        generateGroup(ownerId: currentUID)
                    }) {
                        Text("グループ作成とQRコード生成")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .disabled(isSaving)
                } else {
                    Button(action: {
                        saveGroupToFirebase(ownerId: currentUID)
                    }) {
                        Text("メンバー追加完了")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .disabled(isSaving)
                }

                if let successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            } else {
                Text("ユーザーIDを取得できませんでした")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)

        let context = CIContext()
        if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    private func generateGroup(ownerId: String) {
        Task {
            do {
                isSaving = true
                errorMessage = nil
                successMessage = nil

                let groupId = UUID().uuidString
                generatedGroupId = groupId
                successMessage = "グループIDが生成されました: \(groupId)"
                isSaving = false
            } catch {
                errorMessage = "グループの生成に失敗しました: \(error.localizedDescription)"
                isSaving = false
            }
        }
    }

    private func saveGroupToFirebase(ownerId: String) {
        Task {
            do {
                isSaving = true
                errorMessage = nil
                successMessage = nil

                guard let groupId = generatedGroupId else {
                    errorMessage = "グループIDが生成されていません"
                    isSaving = false
                    return
                }

                let group = GroupModel(id: groupId, name: groupName, createdAt: Date(), members: [ownerId])
                try await FirebaseClient.createGroup(group: group)
                successMessage = "グループが保存されました: \(groupId)"
                isSaving = false
            } catch {
                errorMessage = "グループの保存に失敗しました: \(error.localizedDescription)"
                isSaving = false
            }
        }
    }
}
