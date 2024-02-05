import SwiftUI

struct SwipeStateKey: PreferenceKey {
    static var defaultValue = SwipeState.ended

    static func reduce(
        value: inout SwipeState,
        nextValue: () -> SwipeState
    ) {
        value = nextValue()
    }
}
