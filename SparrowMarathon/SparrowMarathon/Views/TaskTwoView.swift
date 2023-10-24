//
//  TaskTwo.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 04.10.2023.
//

import SwiftUI

private enum Constants {
    static let minInfoWidth: CGFloat = 100
    static let maxInfoWidth: CGFloat = 300
    static let subtitle = "«Отцовский Пинок»"
}

struct TaskTwoView: View {
    @State private var infoViewWidth: CGFloat = Constants.minInfoWidth

    var body: some View {
        VStack {
            InfoView(subtitle: Constants.subtitle)
                .frame(width: infoViewWidth)

            Slider(
                value: $infoViewWidth,
                in: Constants.minInfoWidth...Constants.maxInfoWidth,
                step: 0.5
            )
            .padding(.horizontal, 16)
        }
    }
}

extension TaskTwoView {
    private struct InfoView: View {
        let subtitle: String

        private var firstText: Text {
            Text("Марафон")
                .foregroundStyle(.gray)
        }

        private var secondText: Text {
            Text("по SwiftUI")
                .foregroundStyle(.black)
        }

        private var thirdText: Text {
            Text(subtitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
        }

        var body: some View {
            Text("\(firstText) \(secondText)\n\(thirdText)")
                .font(.title)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .border(.red)
        }
    }
}

#Preview {
    TaskTwoView()
}
