//
//  TaskEightView.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 22.10.2023.
//

import SwiftUI

private enum Constants {
    static let barWidth: CGFloat = 100
    static let barHeight: CGFloat = 300
}

struct TaskEightView: View {
    @State private var volume: CGFloat = 50 {
        didSet {
            guard volume != oldValue else {
                return
            }

            scaleCalculator.configureVolume(with: volume)
        }
    }
    @State private var volumeChange: CGFloat = 0 {
        didSet {
            guard volumeChange != oldValue else {
                return
            }

            scaleCalculator.configureVolumeChange(with: volumeChange)
        }
    }
    @State private var scaleCalculator = ScaleCalculator()

    private var backgroundView: some View {
        Color.gray
            .ignoresSafeArea()
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in setVolumeChange(value: value) }
            .onEnded { _ in changeVolume() }
    }

    var body: some View {
        ZStack {
            backgroundView

            let scaleEffect = scaleEffect()
            VolumeView(volume: volume, volumeChanges: volumeChange)
                .scaleEffect(x: scaleEffect.x, y: scaleEffect.y)
                .offset(y: offsetY())
                .animation(.linear, value: volumeChange)
                .gesture(dragGesture)
        }
    }

    // MARK: - methods

    private func scaleEffect() -> (x: CGFloat, y: CGFloat) {
        scaleCalculator.scaleEffect()
    }

    private func offsetY() -> CGFloat {
        scaleCalculator.offsetY()
    }

    private func setVolumeChange(value: DragGesture.Value) {
        let dragDelta = value.startLocation.y - value.location.y
        volumeChange = dragDelta
    }

    private func changeVolume() {
        volume = min(max(volume + volumeChange, 0), Constants.barHeight)
        volumeChange = 0
    }
}

extension TaskEightView {
    fileprivate struct VolumeView: View {
        let volume: CGFloat
        let volumeChanges: CGFloat

        var body: some View {
            Rectangle()
                .fill(.thinMaterial)
                .frame(width: Constants.barWidth, height: Constants.barHeight)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.white)
                        .clipShape(
                            ClippedRectangle(height: -(volume + volumeChanges))
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
    }
}

extension TaskEightView.VolumeView {
    private struct ClippedRectangle: Shape {
        let height: CGFloat

        func path(in rect: CGRect) -> Path {
            Path { path in
                path.addRect(
                    CGRect(
                        x: rect.origin.x,
                        y: rect.size.height,
                        width: rect.size.width,
                        height: height
                    )
                )
            }
        }
    }
}

extension TaskEightView {
    private struct ScaleCalculator {
        private var volume: CGFloat = 0
        private var volumeChange: CGFloat = 0

        // MARK: - computed properties

        private var newVolume: CGFloat {
            volume + volumeChange
        }

        private var scale: CGFloat {
            newVolume > Constants.barHeight
            ? newVolume / Constants.barHeight
            : 1 + -(newVolume / Constants.barHeight)
        }

        private var scaleX: CGFloat {
            scale > 1 ? max(1 / scale * 0.005, 0.90) : 1.0
        }

        private var scaleY: CGFloat {
            scale > 1 ? min(scale, 1.05) : 1.0
        }

        // MARK: - mutating functions

        mutating func configureVolume(with volume: CGFloat) {
            self.volume = volume
        }

        mutating func configureVolumeChange(with volumeChange: CGFloat) {
            self.volumeChange = volumeChange
        }

        // MARK: - internal functions

        func scaleEffect() -> (x: CGFloat, y: CGFloat) {
            (x: scaleX, y: scaleY)
        }

        func offsetY() -> CGFloat {
            guard scale > 1 else {
                return 1.0
            }

            let newScale = scale * 10
            return newVolume > 0 ? -newScale : newScale
        }
    }
}

#Preview {
    TaskEightView()
}
