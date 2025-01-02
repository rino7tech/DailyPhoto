//
//  HomeView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.isLoggedIn {
                SignInView()
            } else {
                VStack {
                    if viewModel.name.isEmpty {
                        Text("読み込み中...")
                            .font(.headline)
                    } else {
                        Text("ようこそ、\(viewModel.name)さん！")
                            .font(.largeTitle)
                            .padding()
                    }

                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("ログアウト")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }

                    Text("これはホーム画面です。")
                }
                .padding()
                .onAppear {
                    viewModel.fetchProfile()
                }

            }
        }
    }
}
