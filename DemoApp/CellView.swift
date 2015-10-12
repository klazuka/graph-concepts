import UIKit

class CellView: UIView {
  
  let label = UILabel()
  
  required init?(coder aDecoder: NSCoder) { fatalError("not implemented") }
  
  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label.text = "CELL"
    label.textColor = .blackColor()
    label.backgroundColor = .grayColor()
    addSubview(label)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    label.frame = bounds.insetBy(dx: 4, dy: 4)
  }

}
