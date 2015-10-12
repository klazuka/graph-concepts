import XCTest
@testable import SwiftGraphLibrary

func get(name: CellName, _ cells: ParsedCells) -> Cell {
  let (targetRow, targetColumn) = rowAndColumnFromCellName(name)
  for (row, column, formula) in cells {
    if row == targetRow && column == targetColumn {
      return formula
    }
  }
  fatalError("could not find formula with name \(name)")
}

class SpreadsheetTests: XCTestCase {
  
  func testSimple() {
    
    let input = "100|42\n=PRODUCT(A1,B1)|=SUM(A2,B1)"
    
    let formulae = parseText(input)
    XCTAssertEqual(get("A1", formulae), Cell.Number(100))
    XCTAssertEqual(get("B1", formulae), Cell.Number(42))
    XCTAssertEqual(get("A2", formulae), Cell.Product(["A1","B1"]))
    XCTAssertEqual(get("B2", formulae), Cell.Sum(["A2","B1"]))
    
    let graph = buildGraph(formulae)
    
    let result = evaluate(graph)
    XCTAssertEqual(result["A1"]!, 100.0)
    XCTAssertEqual(result["A2"]!, 4200.0)
    XCTAssertEqual(result["B1"]!, 42.0)
    XCTAssertEqual(result["B2"]!, 4242.0)
  }
  
}
