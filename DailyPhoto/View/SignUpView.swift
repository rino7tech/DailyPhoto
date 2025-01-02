//
//  SignUpView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel

    @State private var isUsernameFocused: Bool = false
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.height * 0.5)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)

            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)

                VStack(spacing: 16) {
                    TextField("Username", text: $viewModel.name, onEditingChanged: { editing in
                        withAnimation {
                            isUsernameFocused = editing
                        }
                    })
                    .padding()
                    .background(isUsernameFocused ? Color.blue.opacity(0.1) : Color.white)
                    .cornerRadius(12)
                    .shadow(color: isUsernameFocused ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isUsernameFocused ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                    )

                    TextField("Email", text: $viewModel.email, onEditingChanged: { editing in
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

                    SecureField("Password", text: $viewModel.password)
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
                    viewModel.signUpAndLogin()
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
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
                    let loginView = UIHostingController(rootView: LoginView())
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = loginView
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("Sign Inに戻る")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
            }
        }
        .animation(.easeInOut, value: viewModel.errorMessage)
    }
}
