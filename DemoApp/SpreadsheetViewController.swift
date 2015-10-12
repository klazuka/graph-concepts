import UIKit

let numRows = 5
let numColumns = 3

class SpreadsheetViewController: UIViewController {
  
  let scrollView = UIScrollView()
  var cellViews = [CellView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.backgroundColor = .yellowColor()
    view.addSubview(scrollView)
    
    for row in 0..<numRows {
      for column in 0..<numColumns {
        let cellView = CellView()
        
        let hue = CGFloat(row) / CGFloat(numRows - 1)
        let saturation = 0.2 + (0.6 * (CGFloat(column) / CGFloat(numColumns - 1)))
        cellView.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
        
        scrollView.addSubview(cellView)
        cellViews.append(cellView)
      }
    }
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    scrollView.frame = view.bounds
    
    let cellHeight: CGFloat = 44.0
    let cellWidth = view.bounds.size.width / CGFloat(numColumns)

    for row in 0..<numRows {
      for column in 0..<numColumns {
        let cellView = cellViews[row*numColumns+column]
        cellView.frame = CGRect(
          x: cellWidth * CGFloat(column),
          y: cellHeight * CGFloat(row),
          width: cellWidth,
          height: cellHeight)
      }
    }
    
    scrollView.contentSize = CGSize(
      width: CGFloat(numColumns) * cellWidth,
      height: CGFloat(numRows) * cellHeight)

    
  }
  
}
