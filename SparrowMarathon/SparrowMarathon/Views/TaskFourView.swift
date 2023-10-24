//
//  TaskFourView.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 09.10.2023.
//

import SwiftUI

private enum Constants {
    static let minIconHeight: CGFloat = 0.34
    static let iconHeight: CGFloat = 50
    static let buttonHeight: CGFloat = 100
}

struct TaskFourView: View {
    var body: some View {
        HStack(spacing: 32) {
            ButtonView(
                animationDuration: 0.22,
                scale: 0.86
            )

            ButtonView(
                animationDuration: 2,
                scale: 0
            )
        }
    }
}


extension TaskFourView {
    fileprivate struct ButtonView: View {
        @State private var animationTriggered = false

        let animationDuration: TimeInterval
        let scale: CGFloat

        var body: some View {
            Button(action: { animationTriggered.toggle() }) {
                IconsView(
                    animationTriggered: $animationTriggered,
                    animationDuration: animationDuration
                )
                .frame(width: Constants.buttonHeight, height: Constants.buttonHeight)
            }
            .buttonStyle(
                CustomButtonStyle(
                    animationDuration: animationDuration,
                    scale: scale
                )
            )
        }
    }
}

extension TaskFourView.ButtonView {
    private struct IconsView: View {
        private var playImage: some View {
            Image(systemName: "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }

        @Binding var animationTriggered: Bool

        let animationDuration: TimeInterval

        var body: some View {
            HStack(spacing: 0) {
                playImage
                    .opacity(animationTriggered ? 1 : 0)
                    .scaleEffect(animationTriggered ? 1 : 0, anchor: .trailing)
                    .frame(height: animationTriggered ? Constants.iconHeight : Constants.minIconHeight)

                playImage
                    .frame(height: Constants.iconHeight)

                playImage
                    .opacity(animationTriggered ? 0 : 1)
                    .scaleEffect(animationTriggered ? 0 : 1, anchor: .trailing)
                    .frame(height: animationTriggered ? Constants.minIconHeight : Constants.iconHeight)
            }
            .animation(
                animationTriggered
                    ? .bouncy(duration: animationDuration)
                    : .none,
                value: animationTriggered
            )
            .onChange(of: animationTriggered, { oldValue, newValue in
                if !newValue {
                    animationTriggered = true
                }
            })
        }
    }
}

extension TaskFourView.ButtonView {
    private struct CustomButtonStyle: ButtonStyle {
        @State private var animationTriggered = false

        let animationDuration: TimeInterval
        let scale: CGFloat

        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                Circle()
                    .frame(height: Constants.buttonHeight)
                    .foregroundColor(.gray.opacity(0.3))
                    .opacity(animationTriggered ? 1 : 0)

                configuration.label
                    .foregroundColor(.blue)
                    .scaleEffect(animationTriggered ? scale : 1)
            }
            .animation(.easeInOut(duration: animationDuration))
            .onChange(of: configuration.isPressed, initial: false, { _, _ in
                animationTriggered = true
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + animationDuration
                ) {
                    animationTriggered = configuration.isPressed
                }
            })
        }
    }
}

#Preview {
    TaskFourView()
}
