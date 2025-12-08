import SwiftUI

private struct PagingDisabledModifier: ViewModifier {
    let disabled: Bool

    func body(content: Content) -> some View {
        content.environment(\.pagingDisabled, disabled)
    }
}

public extension View {
    func pagingDisabled(_ disabled: Bool) -> some View {
        modifier(PagingDisabledModifier(disabled: disabled))
    }
}
