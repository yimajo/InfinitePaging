/*
 InfinitePagingViewModifier.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/10/22.
*/

import SwiftUI

struct InfinitePagingViewModifier<T: Pageable>: ViewModifier {
    @Environment(\.pagingDisabled) private var isPagingDisabled: Bool
    @Binding private var objects: [T]
    @Binding private var pageSize: CGFloat
    @Binding private var swipeState: SwipeState
    @State private var pagingOffset: CGFloat
    @State private var draggingOffset: CGFloat
    private let minimumDistance: CGFloat
    private let pageAlignment: PageAlignment
    private let pagingHandler: (PageDirection) -> Void

    private func endDragging(animation: Animation? = nil) {
        let setDragEndedState = {
            draggingOffset = 0
            swipeState = .ended
        }

        if let animation {
            withAnimation(animation) {
                setDragEndedState()
            }
        } else {
            setDragEndedState()
        }
    }

    private func centerPagingOffset(to index: Int = 0) {
        pagingOffset = -pageSize * CGFloat(index)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance)
            .onChanged { value in
                guard !isPagingDisabled else {
                    endDragging()
                    return
                }

                let mainScalar = pageAlignment.scalar(value.translation)
                if swipeState == .ended {
                    let crossScalar = pageAlignment.crossScalar(
                        value.translation
                    )

                    guard abs(crossScalar) <= abs(mainScalar) * 2 else {
                        return
                    }
                    swipeState = .began
                }

                draggingOffset = mainScalar
            }
            .onEnded { value in
                guard !isPagingDisabled else {
                    endDragging()
                    return
                }

                let oldIndex = Int(floor(0.5 - (pagingOffset / pageSize)))
                pagingOffset += pageAlignment.scalar(value.translation)
                draggingOffset = 0
                let newIndex = {
                    let predicatedOffset = pageAlignment.scalar(
                        value.predictedEndTranslation
                    )
                    let predictedPageIndex = Int(
                        (1 - predicatedOffset / pageSize).rounded()
                    )
                    return max(0, min(2, predictedPageIndex))
                }()

                withAnimation(.smooth(duration: 0.1)) {
                    centerPagingOffset(to: newIndex)
                } completion: {
                    defer {
                        endDragging()
                    }

                    guard newIndex != oldIndex else { return }

                    if newIndex == 0 {
                        pagingHandler(.backward)
                    }
                    if newIndex == 2 {
                        pagingHandler(.forward)
                    }
                }
            }
    }

    init(
        objects: Binding<[T]>,
        pageSize: Binding<CGFloat>,
        minimumDistance: CGFloat,
        pageAlignment: PageAlignment,
        pagingHandler: @escaping (PageDirection) -> Void,
        swipeState: Binding<SwipeState>
    ) {
        _objects = objects
        _pageSize = pageSize
        _pagingOffset = State(initialValue: -pageSize.wrappedValue)
        _draggingOffset = State(initialValue: 0)
        self.minimumDistance = minimumDistance
        self.pageAlignment = pageAlignment
        self.pagingHandler = pagingHandler
        _swipeState = swipeState
    }

    func body(content: Content) -> some View {
        content
            .offset(pageAlignment.offset(pagingOffset + draggingOffset))
            .simultaneousGesture(dragGesture)
            .onChange(of: objects) { _, _ in
                centerPagingOffset()
            }
            .onChange(of: pageSize) { _, _ in
                centerPagingOffset()
            }
            .onChange(of: swipeState) { oldState, newState in
                guard newState == .ended, draggingOffset != 0 else {
                    return
                }
                endDragging(animation: .interactiveSpring)
            }
    }
}
