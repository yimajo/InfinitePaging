import SwiftUI

private struct SwipeStateChangeModifier: ViewModifier {
    let action: (SwipeState) -> Void

    func body(content: Content) -> some View {
        content.onPreferenceChange(SwipeStateKey.self) { state in
            action(state)
        }
    }
}

public extension View {
    func onSwipeStateChange(
        _ action: @escaping (SwipeState) -> Void
    ) -> some View {
        modifier(SwipeStateChangeModifier(action: action))
    }
}
