//
//  TaskNineView.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 24.10.2023.
//

import SwiftUI

private enum Constants {
    static let ballSize = CGSize(width: 150, height: 150)
}

struct TaskNineView: View {
    @State private var dragOffset: CGSize = .zero

    private var ballIndices: [Int] = [1, 2]

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                singleMetaBall
            }
        }
    }

    private var singleMetaBall: some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.5, color: .white))
            context.addFilter(.blur(radius: 30))
            context.drawLayer { graphicContext in
                for index in ballIndices {
                    if let resolvedView = graphicContext.resolveSymbol(id: index) {
                        graphicContext.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                    }
                }
            }
        } symbols: {
            Ball()
                .tag(1)

            Ball(offset: dragOffset)
                .tag(2)
        }
        .gesture(gesture)
    }

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
               dragOffset = value.translation
            }.onEnded { _ in onEndAnimation() }
    }

    private func onEndAnimation() {
        withAnimation(
            .interactiveSpring(
                response: 0.6,
                dampingFraction: 0.7,
                blendDuration: 0.7
            )
        ) {
            dragOffset = .zero
        }
    }

    @ViewBuilder
    private func Ball(offset: CGSize = .zero) -> some View {
        Circle()
            .frame(width: Constants.ballSize.width, height: Constants.ballSize.height)
            .offset(offset)
    }
}

#Preview {
    TaskNineView()
}
