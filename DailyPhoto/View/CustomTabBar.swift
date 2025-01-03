//
//  CustomTabBar.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI

var tabs = ["house.fill", "gift.fill"]

struct CustomTabBar: View {
    @State var selectedtab = "house.fill"

    init() {
        UITabBar.appearance().isHidden = true
    }

    @State var xAxis: CGFloat = 0
    @Namespace var animation
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedtab) {
                HomeView()
                    .ignoresSafeArea()
                    .tag("house.fill")
                if authViewModel.isLoggedIn, let uid = authViewModel.currentUID {
                    ImageListView(uid: uid)
                        .ignoresSafeArea()
                        .tag("gift.fill")
                }
            }

            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedtab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                            provideHapticFeedback()
                        }, label: {
                            Image(systemName: image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedtab == image ? getColor(image: image) : Color.gray)
                                .padding(selectedtab == image ? 10 : 0)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .shadow(color: selectedtab == image ? getColor(image: image).opacity(0.5) : Color.clear, radius: 10, x: 0, y: 5)
                                        .scaleEffect(selectedtab == image ? 1.2 : 1)
                                        .opacity(selectedtab == image ? 1 : 0)
                                        .animation(.easeInOut(duration: 0.2), value: selectedtab)
                                )
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: selectedtab == image ? (reader.frame(in: .global).minX - reader.frame(in: .global).midX) : 0, y: selectedtab == image ? -43 : 0)
                        })
                        .onAppear(perform: {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25, height: 30)
                    if image != tabs.last { Spacer(minLength: 0) }
                }
            }
            .padding(.horizontal, 90)
            .padding(.vertical, 20)
            .background(
                Color.white.opacity(0.9)
                    .blur(radius: 0.1)
                    .clipShape(CustomTabShape(xAxis: xAxis))
                    .cornerRadius(12)
                    .shadow(color: selectedtab == tabs.first(where: { $0 == selectedtab }) ? getColor(image: selectedtab).opacity(0.5) : Color.clear, radius: 10, x: 0, y: 5)
            )
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    func getColor(image: String) -> Color {
        switch image {
        case "house.fill":
            return Color.blue
        case "gift.fill":
            return Color.pink
        default:
            return Color.blue
        }
    }

    func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct CustomTabShape: Shape {
    var xAxis: CGFloat
    var offset: CGFloat = 10

    var animatableData: CGFloat {
        get { return xAxis }
        set { xAxis = newValue }
    }

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))

            let center = xAxis + offset
            path.move(to: CGPoint(x: center - 70, y: 0))

            let to1 = CGPoint(x: center, y: 40)
            let control1 = CGPoint(x: center - 35, y: 0)
            let control2 = CGPoint(x: center - 35, y: 40)

            let to2 = CGPoint(x: center + 70, y: 0)
            let control3 = CGPoint(x: center + 35, y: 40)
            let control4 = CGPoint(x: center + 35, y: 0)

            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
