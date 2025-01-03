//
//  ContentView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        if authViewModel.isLoggedIn, let uid = authViewModel.currentUID {
            MainQRCodeView()
        } else {
            SignInView(viewModel: authViewModel)
        }
    }
}

#Preview {
    ContentView()
}
