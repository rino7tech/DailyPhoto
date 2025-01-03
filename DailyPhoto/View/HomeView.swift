//
//  HomeView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/02.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var takePhoto = false
    @State private var capturedImage: UIImage?
    @State private var flashEnabled = false
    @State private var showPreview = true

    var body: some View {
        VStack {
            if showPreview {
                CameraView(
                    takePhoto: $takePhoto,
                    capturedImage: $capturedImage,
                    showPreview: $showPreview,
                    flashEnabled: $flashEnabled
                )
                .frame(height: 400)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
            } else if let image = capturedImage {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))

                    Button(action: {
                        Task {
                            await viewModel.saveImage(image: image)
                            showPreview = true
                            capturedImage = nil
                        }
                    }) {
                        Text(viewModel.isSaving ? "Saving..." : "Save Image")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isSaving)
                }
            }

            HStack {
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
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}
