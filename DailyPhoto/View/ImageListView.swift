//
//  ImageListView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI
import Kingfisher

struct ImageListView: View {
    @StateObject private var viewModel = ImageListViewModel()
    let uid: String

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if viewModel.images.isEmpty {
                    Text("No images found.")
                } else {
                    List(viewModel.images, id: \.url) { image in
                        HStack {
                            KFImage(URL(string: image.url))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            Text(image.uploadedAt, style: .date)
                        }
                    }
                }
            }
            .navigationTitle("Your Images")
            .task {
                await viewModel.fetchImages(uid: uid)
            }
            .refreshable {
                await viewModel.fetchImages(uid: uid)
            }
        }
    }
}
