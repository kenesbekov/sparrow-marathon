//
//  TaskSixView.swift
//  SparrowMarathon
//
//  Created by Adam Kenesbekov on 16.10.2023.
//

import SwiftUI

private enum Constants {
    static let numberOfItems = 7
    static let horizontalSpacing: CGFloat = 8
}

fileprivate enum LayoutKind {
    case horizontal
    case diagonal

    mutating func toggle() {
        switch self {
        case .horizontal:
            self = .diagonal
        case .diagonal:
            self = .horizontal
        }
    }
}

fileprivate func rectSize(
    fromTotalSize totalSize: CGSize,
    numberOfElements: Int,
    in layoutKind: LayoutKind
) -> CGFloat {
    let numberOfElements = CGFloat(numberOfElements)

    let size = switch layoutKind {
    case .horizontal:
        (totalSize.width - (Constants.horizontalSpacing * (numberOfElements - 1))) / numberOfElements
    case .diagonal:
        totalSize.height / numberOfElements
    }

    return size
}

struct TaskSixView: View {
    @State private var layoutKind: LayoutKind = .horizontal

    var body: some View {
        GeometryReader { proxy in
            let size = rectSize(fromTotalSize: proxy.size, numberOfElements: Constants.numberOfItems, in: layoutKind)

            CustomLayout(layoutKind: layoutKind) {
                ForEach(0..<Constants.numberOfItems, id: \.self) { index in
                    Button(action: buttonDidTap) {
                        makeRectangle(withSize: size)
                    }
                }
            }
        }
    }

    private func buttonDidTap() {
        withAnimation {
            layoutKind.toggle()
        }
    }

    private func makeRectangle(withSize size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: size / 8)
            .fill(.blue)
            .frame(width: size, height: size)
    }
}

extension TaskSixView {
    fileprivate struct CustomLayout: Layout {
        let layoutKind: LayoutKind

        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
            proposal.replacingUnspecifiedDimensions()
        }

        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
            guard
                !subviews.isEmpty,
                subviews.count > 1
            else {
                let point = CGPoint(x: bounds.midX, y: bounds.midY)
                subviews.first?.place(at: point, anchor: .center, proposal: .unspecified)

                return
            }
            
            let numberOfSubviews = subviews.count
            let size = rectSize(fromTotalSize: bounds.size, numberOfElements: numberOfSubviews, in: layoutKind)

            for (index, subview) in subviews.enumerated() {
                var x: CGFloat = 0
                var y: CGFloat = bounds.maxY

                switch layoutKind {
                case .horizontal:
                    x += CGFloat(index) * (size + Constants.horizontalSpacing)
                    y = bounds.midY
                case .diagonal:
                    x += (CGFloat(index) * ((bounds.width - size) / CGFloat(numberOfSubviews - 1)))
                    y -= size * CGFloat(index)
                }

                subview.place(at: CGPoint(x: x, y: y), anchor: .bottomLeading, proposal: .unspecified)
            }
        }
    }
}

#Preview {
    TaskSixView()
}
