//
//  HomeView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var authViewModel = AuthViewModel()
    var body: some View {
        VStack {
            Text("ようこそ！")
                .font(.largeTitle)
                .padding()
            Button(action: {
                authViewModel.logout()
            }) {
                Text("ログアウト")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
    }
}
