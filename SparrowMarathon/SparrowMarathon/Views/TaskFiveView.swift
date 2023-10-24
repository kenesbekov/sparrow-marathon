//
//  TaskFiveView.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 12.10.2023.
//

import SwiftUI

struct TaskFiveView: View {
    @State private var offset = CGSize.zero

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                }
            }
    }

    var body: some View {
        ZStack {
            RainbowView()
            VisibleSquareView()
                .offset(offset)
                .gesture(dragGesture)
        }
        .ignoresSafeArea()
    }
}

// MARK: - Visible Square

extension TaskFiveView {
    struct VisibleSquareView: View {
        private let size: CGFloat = 100

        private var rectangle: some View {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: size, height: size)
        }

        var body: some View {
            rectangle.foregroundColor(.white)
                .blendMode(.difference)
                .overlay(rectangle.blendMode(.hue))
                .overlay(rectangle.foregroundColor(.white).blendMode(.overlay))
                .overlay(rectangle.foregroundColor(.black).blendMode(.overlay))
        }
    }
}

// MARK: - Background Colors

extension TaskFiveView {
    private struct ColorsView: View {
        private var colors: [Color] {
            [
                .white,
                .pink,
                .yellow,
                .black
            ]
        }

        var body: some View {
            VStack(spacing: 0) {
                ForEach(colors, id: \.self) { color in
                    color
                }
            }
        }
    }
}

extension TaskFiveView {
    private struct RainbowView: View {
        private let hueColors = stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        }

        var body: some View {
            LinearGradient(
                gradient: Gradient(colors: hueColors),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    TaskFiveView()
}
