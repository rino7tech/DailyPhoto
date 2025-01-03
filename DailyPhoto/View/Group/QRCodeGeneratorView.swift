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
    @State private var groupMembers: [String] = [] // メンバーリスト
    @State private var shouldShowTabBar = false // 遷移フラグ
    let groupName = "My Group" // グループ名を適宜変更

    var body: some View {
        if shouldShowTabBar {
            CustomTabBar() // 完全にタブバーへ切り替える
        } else {
            VStack(spacing: 20) {
                if let currentUID = authViewModel.currentUID {
                    Text("QRコードを生成して共有してください")
                        .font(.headline)
                        .padding()

                    if let qrCodeContent = generatedGroupId {
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
                    }

                    Text("参加メンバー")
                        .font(.title2)
                        .padding(.top)

                    if groupMembers.isEmpty {
                        Text("まだメンバーはいません")
                            .foregroundColor(.gray)
                    } else {
                        List(groupMembers, id: \.self) { member in
                            Text(member)
                                .font(.body)
                        }
                    }

                    Button(action: {
                        if let groupId = generatedGroupId {
                            fetchGroupMembers(groupId: groupId)
                        }
                    }) {
                        Text("参加メンバーをリロード")
                            .font(.body)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }

                    Button(action: {
                        shouldShowTabBar = true // 完全にタブバーに切り替え
                    }) {
                        Text("完了")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top)
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
            .onAppear {
                generateGroupAndQRCode()
            }
            .padding()
        }
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

    private func generateGroupAndQRCode() {
        guard let currentUID = authViewModel.currentUID else {
            errorMessage = "ユーザーIDが取得できませんでした"
            return
        }

        Task {
            do {
                isSaving = true
                errorMessage = nil
                successMessage = nil

                let groupId = UUID().uuidString // ユニークなグループIDを生成
                generatedGroupId = groupId

                // Firebase にグループを保存
                let group = GroupModel(id: groupId, name: groupName, createdAt: Date(), members: [currentUID])
                try await FirebaseClient.createGroup(group: group)

                successMessage = "グループが作成され、QRコードが生成されました: \(groupId)"
                fetchGroupMembers(groupId: groupId) // メンバー情報を取得
                isSaving = false
            } catch {
                errorMessage = "グループの作成に失敗しました: \(error.localizedDescription)"
                isSaving = false
            }
        }
    }

    private func fetchGroupMembers(groupId: String) {
        Task {
            do {
                let group = try await FirebaseClient.fetchGroup(groupId: groupId)
                groupMembers = group.members
            } catch {
                errorMessage = "参加者の取得に失敗しました: \(error.localizedDescription)"
            }
        }
    }
}
