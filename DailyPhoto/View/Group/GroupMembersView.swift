//
//  GroupMembersView.swift
//  DailyPhoto
//
//  Created by 伊藤璃乃 on 2025/01/03.
//

import SwiftUI

struct GroupMembersView: View {
    @ObservedObject var viewModel: GroupViewModel
    var groupId: String

    var body: some View {
        VStack {
            Text("グループメンバー")
                .font(.largeTitle)
                .bold()
                .padding()

            if viewModel.errorMessage.isEmpty {
                List(viewModel.groupMembers) { member in
                    VStack(alignment: .leading) {
                        Text(member.name)
                            .font(.headline)
                        Text("登録日: \(member.createdAt, formatter: DateFormatter.shortDate)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchGroupMembers(groupId: groupId)
        }
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}
