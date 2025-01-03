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
    @State private var groupMembers: [String] = []
    @State private var shouldShowTabBar = false
    let groupName = "My Group"

    var body: some View {
        if shouldShowTabBar {
            CustomTabBar()
        } else {
            VStack(spacing: 20) {
                if let currentUID = authViewModel.currentUID {
                    Text("QRコードを生成して共有してください")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()

                    if let qrCodeContent = generatedGroupId {
                        if let qrImage = generateQRCode(from: qrCodeContent) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 220, height: 220)

                                Image(uiImage: qrImage)
                                    .resizable()
                                    .interpolation(.none)
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            }
                            .padding()
                        } else {
                            Text("QRコードの生成に失敗しました")
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("参加メンバー")
                            .font(.headline)
                            .padding(.vertical, 10)

                        if groupMembers.isEmpty {
                            Text("まだメンバーはいません")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        } else {
                            List(groupMembers, id: \.self) { member in
                                Text(member)
                                    .font(.body)
                            }
                            .frame(maxHeight: 150)
                            .cornerRadius(10)
                        }
                    }

                    Button(action: {
                        if let groupId = generatedGroupId {
                            fetchGroupMembers(groupId: groupId)
                        }
                    }) {
                        HStack {
                            if isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            }
                            Text("参加メンバーをリロード")
                        }
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }

                    Button(action: {
                        shouldShowTabBar = true
                    }) {
                        Text("完了")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top)

                } else {
                    Text("ユーザーIDを取得できませんでした")
                        .font(.body)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .onAppear {
                generateGroupAndQRCode()
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    // 以下のメソッドはそのまま
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

                let groupId = UUID().uuidString
                generatedGroupId = groupId

                let group = GroupModel(id: groupId, name: groupName, createdAt: Date(), members: [currentUID])
                try await FirebaseClient.createGroup(group: group)

                successMessage = "グループが作成され、QRコードが生成されました: \(groupId)"
                fetchGroupMembers(groupId: groupId)
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
