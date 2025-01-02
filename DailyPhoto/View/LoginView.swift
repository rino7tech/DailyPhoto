//
//  LoginView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI
import Colorful

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false

    var body: some View {
        ZStack {
            ColorfulView(animation: .easeInOut(duration: 0.5),colors: [.blue, .purple])
                .ignoresSafeArea()
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.5))
                    .frame(width: UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.height * 0.57)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                Spacer()
            }

            VStack(spacing: 20) {
                Spacer()
                Text("ログイン")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)                    .padding(.bottom, 10)

                VStack(spacing: 16) {
                    TextField("メールアドレス", text: $viewModel.email, onEditingChanged: { editing in
                        withAnimation {
                            isEmailFocused = editing
                        }
                    })
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(isEmailFocused ? Color.blue.opacity(0.1) : Color.white)
                    .cornerRadius(12)
                    .shadow(color: isEmailFocused ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isEmailFocused ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                    )

                    SecureField("パスワード", text: $viewModel.password)
                        .padding()
                        .background(isPasswordFocused ? Color.blue.opacity(0.1) : Color.white)
                        .cornerRadius(12)
                        .shadow(color: isPasswordFocused ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
                        .onTapGesture {
                            withAnimation {
                                isPasswordFocused = true
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isPasswordFocused ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)

                Button(action: {
                    viewModel.login()
                }) {
                    Text("ログイン")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)

                Button(action: {
                    let signUpView = UIHostingController(rootView: SignUpView(viewModel: viewModel))
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = signUpView
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("新規登録")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)

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
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .transition(.opacity)
                }

                Spacer()
            }
            .padding(.top, 40)
        }
        .animation(.easeInOut, value: viewModel.errorMessage)
    }
}
