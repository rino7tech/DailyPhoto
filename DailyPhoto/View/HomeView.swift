//
//  HomeView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack {
            if viewModel.name.isEmpty {
                Text("読み込み中...")
                    .font(.headline)
            } else {
                Text("ようこそ、\(viewModel.name)さん！")
                    .font(.largeTitle)
                    .padding()
            }

            Text("これはホーム画面です。")
        }
        .onAppear {
            viewModel.fetchProfile()
        }
        .padding()
    }
}
