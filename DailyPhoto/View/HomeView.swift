//
//  HomeView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var takePhoto = false
    @State private var capturedImage: UIImage?
    @State private var showPreview = true
    @State private var flashEnabled = false

    var body: some View {
        NavigationStack {
            if viewModel.isLoggedIn {

                SignInView()

            } else {
                VStack {
                    if viewModel.name.isEmpty {
                        Text("読み込み中...")
                            .font(.headline)
                    } else {
                        Text(viewModel.name)
                            .font(.largeTitle)
                            .padding()
                    }

                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("ログアウト")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }

                    if showPreview {
                        CameraView(takePhoto: $takePhoto, capturedImage: $capturedImage, showPreview: $showPreview, flashEnabled: $flashEnabled)
                            .frame(height: 400)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                    } else if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 400)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                    }

                    HStack {
                        if !showPreview {
                            Button(action: {
                                showPreview = true
                            }) {
                                Text("Retake")
                                    .font(.title2)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }

                        Button(action: {
                            takePhoto = true
                        }) {
                            Text("Take Photo")
                                .font(.title2)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(showPreview == false)

                        Button(action: {
                            flashEnabled.toggle()
                        }) {
                            Text(flashEnabled ? "Flash: ON" : "Flash: OFF")
                                .font(.title2)
                                .padding()
                                .background(flashEnabled ? Color.yellow : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .onAppear {
                    viewModel.fetchProfile()
                }

            }
        }
        .onAppear {
            print("ログイン\(viewModel.isLoggedIn)")
        }
    }
}
