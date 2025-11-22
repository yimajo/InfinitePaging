/// Represents the state of a swipe gesture within the `InfinitePagingView`.
public enum SwipeState: Sendable {
    /// Indicates that the swipe gesture has begun.
    ///
    /// This state represents the start of the user's swipe action.
    case began

    /// Indicates that the swipe gesture has ended.
    ///
    /// This state is used to represent the completion of a swipe,
    /// regardless of whether it resulted in a page change or not.
    case ended
}
