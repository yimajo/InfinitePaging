import Foundation

enum PageScroll: Int {
    case leftToRightScroll = 0
    case smallScroll
    case rightToLeftScroll

    init?(predicatedOffset: Double, pageLength: Double) {
        let adjustedOffset = 1 - predicatedOffset / pageLength
        let clampedValue = max(0, min(2, round(adjustedOffset)))
        self.init(rawValue: Int(clampedValue))
    }
}
