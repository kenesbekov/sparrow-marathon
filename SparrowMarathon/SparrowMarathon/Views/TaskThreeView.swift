//
//  TaskThreeView.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 05.10.2023.
//

import SwiftUI

private enum Constants {
    static let minIconHeight: CGFloat = 0.34
    static let iconHeight: CGFloat = 50
    static let buttonHeight: CGFloat = 100
}

struct TaskThreeView: View {
    @State private var animationTriggered = false

    var body: some View {
        Button(action: { animationTriggered.toggle() }) {
            IconsView(animationTriggered: $animationTriggered)
                .frame(width: Constants.buttonHeight, height: Constants.buttonHeight)
        }
        .buttonStyle(CustomButtonStyle())
    }
}

extension TaskThreeView {
    private struct IconsView: View {
        private var playImage: some View {
            Image(systemName: "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }

        @Binding var animationTriggered: Bool

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
            .animation(!animationTriggered ? .none : .bouncy(duration: 0.5), value: animationTriggered)
            .onChange(of: animationTriggered, { oldValue, newValue in
                if !newValue {
                    animationTriggered = true
                }
            })
        }
    }
}

extension TaskThreeView {
    private struct CustomButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                Circle()
                    .frame(height: Constants.buttonHeight)
                    .foregroundColor(.gray.opacity(0.3))
                    .opacity(configuration.isPressed ? 1 : 0)

                configuration.label
                    .foregroundColor(.blue)
                    .scaleEffect(configuration.isPressed ? 0.7 : 1)
            }
            .animation(.easeInOut(duration: 0.2))
        }
    }
}

#Preview {
    TaskThreeView()
}
