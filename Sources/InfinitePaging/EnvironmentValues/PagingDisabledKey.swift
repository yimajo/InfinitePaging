import SwiftUI

private struct PagingDisabledKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var pagingDisabled: Bool {
        get { self[PagingDisabledKey.self] }
        set { self[PagingDisabledKey.self] = newValue }
    }
}
