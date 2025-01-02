//
//  AuthViewModel.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignedUp: Bool = false
    @Published var isLoggedIn: Bool = false

    func signUp() {
        Task {
            do {
                // Firebase Authでユーザー作成
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                let uid = authResult.user.uid

                // Firestoreにユーザープロフィールを保存
                let profileModel = ProfileModel(name: name, createdAt: Date())
                try await FirebaseClient.settingProfile(data: profileModel, uid: uid)

                // サインアップ成功
                DispatchQueue.main.async {
                    self.isSignedUp = true
                    self.errorMessage = ""
                }
            } catch {
                // エラー処理
                DispatchQueue.main.async {
                    self.isSignedUp = false
                    self.errorMessage = "エラー: \(error.localizedDescription)"
                }
            }
        }
    }

    func signUpAndLogin() {
            Task {
                do {
                    // Firebase Authでユーザー作成
                    let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                    let uid = authResult.user.uid

                    // Firestoreにユーザープロフィールを保存
                    let profileData = ProfileModel(name: name, createdAt: Date())
                    try await FirebaseClient.settingProfile(data: profileData, uid: uid)

                    // 自動ログイン状態にする
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.errorMessage = ""
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "エラー: \(error.localizedDescription)"
                    }
                }
            }
        }

        func login() {
            Task {
                do {
                    try await Auth.auth().signIn(withEmail: email, password: password)
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.errorMessage = ""
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoggedIn = false
                        self.errorMessage = "ログインエラー: \(error.localizedDescription)"
                    }
                }
            }
        }


    func logout() {
        do {
            // Firebase Authでログアウト
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.errorMessage = ""
            }
        } catch {
            // エラー処理
            DispatchQueue.main.async {
                self.errorMessage = "ログアウトエラー: \(error.localizedDescription)"
            }
        }
    }

    func resetPassword() {
        Task {
            do {
                // Firebase Authでパスワードリセットメール送信
                try await Auth.auth().sendPasswordReset(withEmail: email)

                // 成功メッセージ
                DispatchQueue.main.async {
                    self.errorMessage = "パスワードリセットメールを送信しました。"
                }
            } catch {
                // エラー処理
                DispatchQueue.main.async {
                    self.errorMessage = "パスワードリセットエラー: \(error.localizedDescription)"
                }
            }
        }
    }
}
