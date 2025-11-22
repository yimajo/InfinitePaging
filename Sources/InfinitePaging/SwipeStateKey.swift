import SwiftUI

struct SwipeStateKey: PreferenceKey {
    static let defaultValue: SwipeState = .ended

    static func reduce(
        value: inout SwipeState,
        nextValue: () -> SwipeState
    ) {
        value = nextValue()
    }
}
