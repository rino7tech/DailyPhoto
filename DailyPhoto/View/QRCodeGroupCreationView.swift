//
//  QRCodeGroupCreationView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI

struct QRCodeGroupCreationView: View {
    @State private var scannedGroupId: String?
    @State private var isScanning = false
    @State private var isLoading = false
    @State private var errorMessage: String?

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if let scannedGroupId {
                Text("グループID: \(scannedGroupId)")
                    .padding()

                Button(action: {
                    createGroupWithScannedID(groupId: scannedGroupId)
                }) {
                    Text("グループ作成を承認")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
            } else {
                Button(action: {
                    isScanning = true
                }) {
                    Text("QRコードをスキャン")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }

            if isLoading {
                ProgressView()
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $isScanning) {
            QRCodeScannerView { scannedValue in
                scannedGroupId = scannedValue
                isScanning = false
            }
        }
    }

    private func createGroupWithScannedID(groupId: String) {
        guard let currentUserId = authViewModel.currentUID else {
            errorMessage = "ログインが必要です。"
            return
        }

        Task {
            do {
                isLoading = true
                errorMessage = nil
                try await FirebaseClient.addMemberToGroup(groupId: groupId, memberId: currentUserId)
                isLoading = false
                errorMessage = nil
            } catch {
                isLoading = false
                errorMessage = "グループ作成に失敗しました: \(error.localizedDescription)"
            }
        }
    }
}
