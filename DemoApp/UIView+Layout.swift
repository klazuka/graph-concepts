import UIKit

extension UIView {
  var top: CGFloat { return frame.origin.y }
  var left: CGFloat { return frame.origin.x }
  var bottom: CGFloat { return frame.origin.y + frame.size.height }
  var right: CGFloat { return frame.origin.x + frame.size.width }
}
