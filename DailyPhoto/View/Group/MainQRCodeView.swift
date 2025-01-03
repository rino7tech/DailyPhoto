//
//  MainQRCodeView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI
import Colorful

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
            ZStack {
                ColorfulView(animation: .easeInOut(duration: 0.5), colors: [.customBlue, .customLightBlue.opacity(0.5)])
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.6))
                        .frame(width: UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.height * 0.57)
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                    Spacer()
                }

                VStack(spacing: 20) {
                    Spacer()
                    Text("グループを作成しよう")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.customBlue)
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 3)
                        .padding(.bottom, 10)

                    Text("グループを作成するか、\n グループに参加してください。")
                        .font(.body)
                        .foregroundColor(.customBlue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)

                    Button(action: {
                        isShowingQRCodeGenerator = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("グループを作成する")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.customBlue, Color.customLightBlue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .shadow(color: Color.customBlue.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 32)

                    Button(action: {
                        isShowingQRCodeScanner = true
                    }) {
                        HStack {
                            Image(systemName: "person.3.fill")
                                .font(.title)
                                .foregroundColor(.customBlue)
                            Text("グループに参加する")
                                .font(.headline)
                                .foregroundColor(.customBlue)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(25)
                        .shadow(color: Color.customBlue.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 32)

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                            .padding()
                    }
                    Spacer()
                }
                .sheet(isPresented: $isShowingQRCodeGenerator) {
                    QRCodeGeneratorView()
                        .environmentObject(authViewModel)
                }
                .sheet(isPresented: $isShowingQRCodeScanner) {
                    QRCodeGroupCreationView(navigateToTabBar: $navigateToTabBar)
                        .environmentObject(authViewModel)
                }
                .onAppear {
                    checkUserMembership()
                }
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
