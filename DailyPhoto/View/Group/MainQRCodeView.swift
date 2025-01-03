//
//  QRCodeCompletionView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI

struct MainQRCodeView: View {
    @State private var isShowingQRCodeGenerator = false
    @State private var isShowingQRCodeScanner = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var navigateToTabBar = false
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        if navigateToTabBar {
            CustomTabBar()
        } else {
            NavigationView {
                VStack(spacing: 20) {
                    Text("QRコードを選択")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    Button(action: {
                        isShowingQRCodeGenerator = true
                    }) {
                        Text("QRコードを生成")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)

                    Button(action: {
                        checkUserMembership()
                    }) {
                        Text("グループに所属しているか確認")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)

                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Text("ログアウト")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)

                    if isLoading {
                        ProgressView()
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .sheet(isPresented: $isShowingQRCodeGenerator) {
                    QRCodeGeneratorView()
                        .environmentObject(authViewModel)
                }
                .sheet(isPresented: $isShowingQRCodeScanner) {
                    QRCodeScannerView { scannedValue in
                        // スキャン結果を保持
                        isShowingQRCodeScanner = false
                    }
                }
            }
            .onAppear {
                checkUserMembership()
            }
        }
    }

    private func checkUserMembership() {
        guard let currentUserId = authViewModel.currentUID else {
            errorMessage = "ログインが必要です。"
            return
        }

        Task {
            do {
                isLoading = true
                errorMessage = nil
                let isMember = try await FirebaseClient.isUserInAnyGroup(userId: currentUserId)
                isLoading = false

                if isMember {
                    navigateToTabBar = true
                } else {
                    errorMessage = "どのグループにも所属していません。"
                }
            } catch {
                isLoading = false
                errorMessage = "エラーが発生しました: \(error.localizedDescription)"
            }
        }
    }
}
