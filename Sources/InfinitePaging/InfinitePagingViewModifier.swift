/*
 InfinitePagingViewModifier.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/10/22.
*/

import SwiftUI

struct InfinitePagingViewModifier<T: Pageable>: ViewModifier {
    @Binding var objects: [T]
    @Binding var pageLength: CGFloat
    @State var pagingOffset: CGFloat
    @State var draggingOffset: CGFloat
    private let minimumDistance: CGFloat
    private let snappingAnimation: Animation
    private let pageAlignment: PageAlignment
    private let pagingHandler: (PageDirection) -> Void

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance)
            .onChanged { value in
                draggingOffset = pageAlignment.scalar(value.translation)
            }
            .onEnded { value in
                let oldIndex = Int(floor(0.5 - (pagingOffset / pageLength)))
                pagingOffset += pageAlignment.scalar(value.translation)
                draggingOffset = 0
                let predicatedOffset = pageAlignment.scalar(value.predictedEndTranslation)
                let newIndex = Int(max(0, min(2, round(1 - predicatedOffset / pageLength))))
                if #available(iOS 17.0, *) {
                    withAnimation(snappingAnimation) {
                        pagingOffset = -pageLength * CGFloat(newIndex)
                    } completion: {
                        if newIndex == oldIndex { return }
                        if newIndex == 0 {
                            pagingHandler(.backward)
                        } else if newIndex == 2 {
                            pagingHandler(.forward)
                        }
                    }
                } else {
                    withAnimation(snappingAnimation) {
                        pagingOffset = -pageLength * CGFloat(newIndex)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if newIndex == oldIndex { return }
                        if newIndex == 0 {
                            pagingHandler(.backward)
                        } else if newIndex == 2 {
                            pagingHandler(.forward)
                        }
                    }
                }
            }
    }

    init(
        objects: Binding<[T]>,
        pageLength: Binding<CGFloat>,
        minimumDistance: CGFloat,
        snappingAnimation: Animation,
        pageAlignment: PageAlignment,
        pagingHandler: @escaping (PageDirection) -> Void
    ) {
        _objects = objects
        _pageLength = pageLength
        _pagingOffset = State(initialValue: -pageLength.wrappedValue)
        _draggingOffset = State(initialValue: 0)
        self.minimumDistance = minimumDistance
        self.snappingAnimation = snappingAnimation
        self.pageAlignment = pageAlignment
        self.pagingHandler = pagingHandler
    }

    func body(content: Content) -> some View {
        content
            .offset(pageAlignment.offset(pagingOffset + draggingOffset))
            .simultaneousGesture(dragGesture)
            .onChange(of: objects) { _ in
                pagingOffset = -pageLength
            }
            .onChange(of: pageLength) { _ in
                pagingOffset = -pageLength
            }
    }
}
