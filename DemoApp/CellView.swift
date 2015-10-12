import UIKit

class CellView: UIView {
  
  let field = UITextField()
  var textChangedHandler: (String->Void)!
  
  required init?(coder aDecoder: NSCoder) { fatalError("not implemented") }
  
  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    field.text = nil
    field.textColor = .darkGrayColor()
    field.backgroundColor = .whiteColor()
    field.delegate = self
    addSubview(field)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    field.frame = bounds.insetBy(dx: 4, dy: 4)
  }

}

extension CellView: UITextFieldDelegate {
  
  func textFieldDidEndEditing(textField: UITextField) {
    textChangedHandler(field.text ?? "")
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    resignFirstResponder()
    textChangedHandler(field.text ?? "")
    return true
  }
}
