//
//  TaskSevenView.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 19.10.2023.
//

import SwiftUI

struct TaskSevenView: View {
    @Namespace private var animation
    @State private var isExpandedButton = false

    private var smallButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: buttonDidTap) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                            .matchedGeometryEffect(id: "Shape", in: animation)

                        Text("Open")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .matchedGeometryEffect(id: "Text", in: animation)
                    }
                    .fixedSize()
                }
                .padding(16)
            }
        }
    }

    private var expandedButton: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .matchedGeometryEffect(id: "Shape", in: animation)

            Button(action: buttonDidTap) {
                Text("\(Image(systemName: "arrowshape.backward.fill")) Back")
                    .foregroundColor(.white)
                    .frame(width: 100, height: 50)
                    .matchedGeometryEffect(id: "Text", in: animation)
            }
        }
        .frame(height: 500)
        .padding(.horizontal, 32)
    }

    var body: some View {
        if isExpandedButton {
            expandedButton
        } else {
            smallButton
        }
    }

    private func buttonDidTap() {
        withAnimation(.bouncy) {
            isExpandedButton.toggle()
        }
    }
}

#Preview {
    TaskSevenView()
}
