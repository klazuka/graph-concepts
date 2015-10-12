import UIKit

let numRows = 5
let numColumns = 3

let columnNames = ["A", "B", "C", "D", "E", "F"] // TODO improve

class SpreadsheetViewController: UIViewController {
  
  let scrollView = UIScrollView()
  var columnHeaderViews = [UIView]()
  var cellViews = [CellView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.backgroundColor = .lightGrayColor()
    view.addSubview(scrollView)
    
    // Create the column header
    for column in 0..<numColumns {
      let label = UILabel()
      label.text = columnNames[column]
      label.textAlignment = .Center
      scrollView.addSubview(label)
      columnHeaderViews.append(label)
    }
    
    // Create the row header
    
    // Create the grid
    for _ in 0..<numRows {
      for _ in 0..<numColumns {
        let cellView = CellView()
        
//        let hue = CGFloat(row) / CGFloat(numRows - 1)
//        let saturation = 0.2 + (0.6 * (CGFloat(column) / CGFloat(numColumns - 1)))
//        cellView.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
        cellView.backgroundColor = .darkGrayColor()
        
        scrollView.addSubview(cellView)
        cellViews.append(cellView)
      }
    }
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    scrollView.frame = view.bounds
    
    let headerHeight: CGFloat = 44.0
    
    let cellHeight: CGFloat = 44.0
    let cellWidth = view.bounds.size.width / CGFloat(numColumns)
    
    var flowLayoutY: CGFloat = 20.0 // start out clearing the iOS status bar
    
    for column in 0..<numColumns {
      let columnLabel = columnHeaderViews[column]
      columnLabel.frame = CGRect(
        x: cellWidth * CGFloat(column),
        y: flowLayoutY,
        width: cellWidth,
        height: headerHeight)
    }
    flowLayoutY += headerHeight

    for row in 0..<numRows {
      for column in 0..<numColumns {
        let cellView = cellViews[row*numColumns+column]
        cellView.frame = CGRect(
          x: cellWidth * CGFloat(column),
          y: flowLayoutY + cellHeight * CGFloat(row),
          width: cellWidth,
          height: cellHeight)
      }
    }
    
    scrollView.contentSize = CGSize(
      width: CGFloat(numColumns) * cellWidth,
      height: CGFloat(numRows) * cellHeight)
  }
  
}
