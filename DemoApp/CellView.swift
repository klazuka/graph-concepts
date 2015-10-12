import UIKit

class CellView: UIView {
  
  let label = UITextField()
  
  required init?(coder aDecoder: NSCoder) { fatalError("not implemented") }
  
  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label.text = "CELL"
    label.textColor = .darkGrayColor()
    label.backgroundColor = .whiteColor()
    addSubview(label)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    label.frame = bounds.insetBy(dx: 4, dy: 4)
  }

}
