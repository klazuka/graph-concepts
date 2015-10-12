import UIKit

class CellView: UIView {
  
  let field = UITextField()
  
  required init?(coder aDecoder: NSCoder) { fatalError("not implemented") }
  
  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    field.text = nil
    field.textColor = .darkGrayColor()
    field.backgroundColor = .whiteColor()
    addSubview(field)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    field.frame = bounds.insetBy(dx: 4, dy: 4)
  }

}
