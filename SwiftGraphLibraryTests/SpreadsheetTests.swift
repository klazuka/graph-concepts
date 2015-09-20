import XCTest
@testable import SwiftGraphLibrary

class SpreadsheetTests: XCTestCase {
  
  func testParse() {
    let input = "100|42\n=PRODUCT(A1,B1)|=SUM(A2,B1)"
    let result = parse(input)
    print(result)
  }
  
  func testSimple() {
    let edges = [
      (1,3),
      (2,1),
      (2,3),
      (4,2),
      (4,3)
    ]
    
    let g = AdjacencyListGraph(edges: edges)
    
    let evalOrder = topologicalSort(g)
    XCTAssertEqual(evalOrder, [3, 1, 2, 4])
  }
}
