import Foundation

public typealias CellName = String

public enum Cell {
  case Number(Double)
  case Product([CellName])
  case Sum([CellName])
  
  init?(textContent: String) {
    
    func parseFormulaArgs(text: String) -> [CellName]? {
      guard let begin = textContent.characters.indexOf("(")?.successor(),
            let end = textContent.characters.indexOf(")")?.predecessor()
            else { return nil }
      return textContent[begin...end].componentsSeparatedByString(",")
    }
    
    if textContent.hasPrefix("=PRODUCT") {
      guard let names = parseFormulaArgs(textContent) else { return nil }
      self = .Product(names)
      
    } else if textContent.hasPrefix("=SUM") {
      guard let names = parseFormulaArgs(textContent) else { return nil }
      self = .Sum(names)

    } else {
      guard let x = Double(textContent) else { return nil }
      self = .Number(x)
    }
  }
}

// CSV input where pipes separate columns and newlines separate rows
// example input: "100|42\n=PRODUCT(A1,B1)|=SUM(A2,B1)"
// corresponds to
//
//      | A                | B
//   ---+------------------+--------------
//    1 | 100              | 42
//    2 | =PRODUCT(A1, B1) | =SUM(A2, B1)
//
public func parse(input: String) -> [CellName:Cell] {
  var result = [CellName:Cell]()
  
  for (row, line) in input.componentsSeparatedByString("\n").enumerate() {
    for (col, phrase) in line.componentsSeparatedByString("|").enumerate() {
      let colName = Character(UnicodeScalar(0x41 + col))
      let name = "\(colName)\(row+1)"
      guard let cell = Cell(textContent: phrase) else { fatalError() }
      result[name] = cell
    }
  }

  return result
}

public func evaluate(cells: [CellName:Cell]) -> [CellName:Double] {
  fatalError()
}