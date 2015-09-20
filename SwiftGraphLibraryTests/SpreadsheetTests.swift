import XCTest
@testable import SwiftGraphLibrary

class SpreadsheetTests: XCTestCase {
  
  let input = "100|42\n=PRODUCT(A1,B1)|=SUM(A2,B1)"
  
  func testParse() {
    let result = parse(input)
    print(result)
  }
  
  
  func testSimple() {
    evaluate(parse(input))
  }
}
