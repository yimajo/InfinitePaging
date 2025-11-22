import SwiftUI

public extension InfinitePagingView {
    @ViewBuilder
    func onSwipeStateChange(
        _ action: @escaping (SwipeState) -> Void
    ) -> some View {
        onPreferenceChange(SwipeStateKey.self) {
            action($0)
        }
    }
}
