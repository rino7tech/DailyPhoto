//
//  SignUpView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI
import Colorful

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel

    @State private var isUsernameFocused: Bool = false
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false

    var body: some View {
        ZStack {
            ColorfulView(animation: .easeInOut(duration: 0.5),colors: [.customPink, .customLightPink.opacity(0.5)])
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.5))
                    .frame(width: UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.height * 0.57)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                Spacer()
            }

            VStack(spacing: 20) {
                Text("SignUp")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.customPink)
                    .padding(.bottom, 20)

                VStack(spacing: 16) {
                    TextField("名前", text: $viewModel.name, onEditingChanged: { editing in
                        withAnimation {
                            isUsernameFocused = editing
                        }
                    })
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)

                    TextField("メールアドレス", text: $viewModel.email, onEditingChanged: { editing in
                        withAnimation {
                            isEmailFocused = editing
                        }
                    })
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)

                    SecureField("パスワード", text: $viewModel.password)
                        .padding()
                        .background(Color.white.opacity(0.8))
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
                    viewModel.signUpAndLogin()
                }) {
                    Text("アカウント登録")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.customPink,Color.customLightPink.opacity(0.5)]), startPoint: .bottomLeading, endPoint: .topLeading))
                        .cornerRadius(25)
                        .shadow(color: Color.CustomPink.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .transition(.opacity)
                }

                Button(action: {
                    let loginView = UIHostingController(rootView: SigninView())
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = loginView
                        window.makeKeyAndVisible()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.customPink)
                        Text("サインインへ戻る")
                            .font(.headline)
                            .foregroundColor(.customPink)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(25)
                    .shadow(color: Color.CustomPink.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
            }
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .animation(.easeInOut, value: viewModel.errorMessage)
    }
}
