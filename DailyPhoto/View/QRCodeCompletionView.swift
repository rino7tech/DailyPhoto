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
    @StateObject private var authViewModel = AuthViewModel()
    var body: some View {
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
                    isShowingQRCodeScanner = true
                }) {
                    Text("QRコードを読み込む")
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
            }
            .sheet(isPresented: $isShowingQRCodeGenerator) {
                QRCodeGeneratorView()
                    .environmentObject(authViewModel)
            }
            .sheet(isPresented: $isShowingQRCodeScanner) {
                QRCodeGroupCreationView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
