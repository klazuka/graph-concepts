import UIKit
import SwiftGraphLibrary

let numRows = 2
let numColumns = 2

let columnNames = ["A", "B", "C", "D", "E", "F"] // TODO improve

class SpreadsheetViewController: UIViewController {
  
  // UI
  let scrollView = UIScrollView()
  var columnHeaderViews = [UIView]()
  var rowHeaderViews = [UIView]()
  var cellViews = [CellView]()
  
  // Data
  var graph = CellGraph()
  var lastEval: [CellName:Double] = [:]
  
  
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
    for row in 0..<numRows {
      let label = UILabel()
      label.text = String(row + 1)
      scrollView.addSubview(label)
      rowHeaderViews.append(label)
    }
    
    // Create the grid
    for row in 0..<numRows {
      for column in 0..<numColumns {
        
        let name = makeCellName(row: row, column: column)
        let u = graph.addVertex(CellVertex(name: name, row: row, column: column, formula: .Empty))
        print("added vertex", u, graph[u].name)
        
        let cellView = CellView()
        cellView.backgroundColor = .darkGrayColor()
        scrollView.addSubview(cellView)
        cellViews.append(cellView)
        cellView.textChangedHandler = { newText in
          if let newFormula = Cell(textContent: newText) {
            self.graph[u].formula = newFormula
            self.recalculate()
          }
          else {
            cellView.field.text = "ERROR"
          }
        }
      }
    }
    
    recalculate()
  }
  
  func recalculate() {

    // remove all edges
    for u in graph.vertices() {
      graph.clearVertex(u)
    }
    
    // build the edges
    for u in graph.vertices() {
      let formula = graph[u].formula
      for dependency in formula.dependencies() {
        // TODO find a cleaner and more efficient way to do the dependency lookup
        for v in graph.vertices() {
          if graph[v].name == dependency {
            graph.addEdge(u, v: v)
          }
        }
      }
    }
    
    // evaluate
    lastEval = evaluate(graph)
    
    // update the UI
    for row in 0..<numRows {
      for column in 0..<numColumns {
        let cellView = cellViews[row*numColumns+column]
        let name = makeCellName(row: row, column: column)
        cellView.field.text = String(lastEval[name]!)
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    scrollView.frame = view.bounds
    
    let rowHeaderWidth: CGFloat = 30.0
    let columnHeaderHeight: CGFloat = 44.0
    
    let cellHeight: CGFloat = 44.0
    let cellWidth: CGFloat = 140.0
    
    var flowLayoutY: CGFloat = 20.0 // start just below the iOS status bar
    
    // layout the column header
    for column in 0..<numColumns {
      let columnLabel = columnHeaderViews[column]
      columnLabel.frame = CGRect(
        x: cellWidth * CGFloat(column),
        y: flowLayoutY,
        width: cellWidth,
        height: columnHeaderHeight)
    }
    flowLayoutY += columnHeaderHeight
    
    // layout the grid of cells
    for row in 0..<numRows {
      
      // layout the row header
      let rowLabel = rowHeaderViews[row]
      rowLabel.frame = CGRect(
        x: 0,
        y: flowLayoutY,
        width: rowHeaderWidth,
        height: cellHeight)
      
      // layout the cells within this row
      for column in 0..<numColumns {
        let cellView = cellViews[row*numColumns+column]
        cellView.frame = CGRect(
          x: rowHeaderWidth + cellWidth * CGFloat(column),
          y: flowLayoutY,
          width: cellWidth,
          height: cellHeight)
      }
      
      flowLayoutY += cellHeight
    }
    
    // tell the scroll view how big its content is
    let lastCell = cellViews.last!
    scrollView.contentSize = CGSize(width: lastCell.right, height: lastCell.bottom)
  }
  
}
