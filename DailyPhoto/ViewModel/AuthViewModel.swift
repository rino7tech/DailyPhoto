//
//  AuthViewModel.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignedUp: Bool = false

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "エラー: \(error.localizedDescription)"
                    self?.isSignedUp = false
                } else {
                    self?.errorMessage = ""
                    self?.isSignedUp = true
                }
            }
        }
    }
}
