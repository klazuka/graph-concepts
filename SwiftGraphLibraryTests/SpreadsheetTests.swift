import XCTest
@testable import SwiftGraphLibrary

class SpreadsheetTests: XCTestCase {
  
  func testSimple() {
    
    let input = "100|42\n=PRODUCT(A1,B1)|=SUM(A2,B1)"
    
    let formulae = parse(input)
    XCTAssertEqual(Cell.Number(100), formulae[CellName("A1")]!)
    XCTAssertEqual(Cell.Number(42), formulae[CellName("B1")]!)
    XCTAssertEqual(Cell.Product([CellName("A1"),CellName("B1")]), formulae[CellName("A2")]!)
    XCTAssertEqual(Cell.Sum([CellName("A2"),CellName("B1")]), formulae[CellName("B2")]!)
    
    let result = evaluate(formulae)
    XCTAssertEqual(100.0, result[CellName("A1")]!)
    XCTAssertEqual(42.0, result[CellName("B1")]!)
    XCTAssertEqual(4200.0, result[CellName("A2")]!)
    XCTAssertEqual(4242.0, result[CellName("B2")]!)
  }
}
