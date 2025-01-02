//
//  SignUpView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("新規ユーザー登録")
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
                viewModel.signUp()
            }) {
                Text("登録")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            if viewModel.isSignedUp {
                Text("登録に成功しました！")
                    .foregroundColor(.green)
                    .bold()
            }
        }
        .padding()
    }
}
