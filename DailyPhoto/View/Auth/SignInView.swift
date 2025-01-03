//
//  LoginView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI
import Colorful

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false

    var body: some View {
        ZStack {
            ColorfulView(animation: .easeInOut(duration: 0.5), colors: [.customPink, .customLightPink.opacity(0.5)])
                .ignoresSafeArea()
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.5))
                    .frame(width: UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.height * 0.57)
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                Spacer()
            }

            VStack(spacing: 20) {
                Spacer()
                Text("SignIn")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.customPink)
                    .padding(.bottom, 10)

                VStack(spacing: 16) {
                    TextField("メールアドレス", text: $viewModel.email, onEditingChanged: { editing in
                        withAnimation {
                            isEmailFocused = editing
                        }
                    })
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)

                    SecureField("パスワード", text: $viewModel.password)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                        .onTapGesture {
                            withAnimation {
                                isPasswordFocused = true
                            }
                        }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)

                Button(action: {
                    viewModel.login()
                }) {
                    Text("サインイン")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.customPink, Color.customLightPink.opacity(0.5)]), startPoint: .bottomLeading, endPoint: .topLeading))
                        .cornerRadius(25)
                        .shadow(color: Color.customPink.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)

                Button(action: {
                    viewModel.resetPassword()
                }) {
                    Text("パスワードをお忘れですか？")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.top, 5)
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