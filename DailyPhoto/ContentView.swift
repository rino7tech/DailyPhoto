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
        if authViewModel.isLoggedIn {
            HomeView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    ContentView()
}
