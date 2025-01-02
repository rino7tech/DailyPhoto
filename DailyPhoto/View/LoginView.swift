//
//  LoginView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showSignUpView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("ログイン")
                    .font(.largeTitle)
                    .bold()

                TextField("メールアドレス", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("パスワード", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    viewModel.login()
                }) {
                    Text("ログイン")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    viewModel.resetPassword()
                }) {
                    Text("パスワードを忘れましたか？")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Spacer()

                NavigationLink(
                    destination: SignUpView(viewModel: viewModel),
                    isActive: $showSignUpView
                ) {
                    Button(action: {
                        showSignUpView = true
                    }) {
                        Text("新規登録")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }

                NavigationLink(
                    destination: HomeView(),
                    isActive: $viewModel.isLoggedIn
                ) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}
