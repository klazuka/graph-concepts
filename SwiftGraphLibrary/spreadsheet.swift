import Foundation

public struct CellName: Equatable {
  let row: Int
  let column: Int
  
  init(row: Int, column: Int) {
    self.row = row
    self.column = column
  }
  
  func humanName() -> String {
    let columnLetter = Character(UnicodeScalar(0x41 + column))
    return "\(columnLetter)\(row+1)"
  }
  
  init(humanName: String) {
    // note: only supports columns A-Z, rows 1-9
    assert(humanName.characters.count == 2)
    guard let columnLetter = humanName.utf8.first else { fatalError() }
    let column = Int(columnLetter - 0x41)
    let rowNumText = humanName.utf8[humanName.utf8.startIndex.successor()] - 0x30
    let row = Int(rowNumText) - 1
    self.init(row: row, column: column)
  }
  
}

public func ==(lhs: CellName, rhs: CellName) -> Bool {
  return lhs.row == rhs.row && lhs.column == rhs.column
}

extension CellName: Hashable {
  public var hashValue: Int { return humanName().hash }
}

extension CellName: CustomStringConvertible {
  public var description: String { return humanName() }
}

extension CellName {
  init(vertexDescriptor: Int) {
    // super lazy mapping from 1D to 2D
    let row = vertexDescriptor / 1000
    let column = vertexDescriptor % 1000
    self.init(row: row, column: column)
  }
  
  func toVertexDescriptor() -> Int {
    // super lazy mapping from 2D to 1D
    return row * 1000 + column
  }
}


public enum Cell {
  case Number(Double)
  case Product([CellName])
  case Sum([CellName])
  
  init?(textContent: String) {
    
    func parseFormulaArgs(text: String) -> [CellName]? {
      guard let begin = textContent.characters.indexOf("(")?.successor(),
            let end = textContent.characters.indexOf(")")?.predecessor()
            else { return nil }
      return textContent[begin...end].componentsSeparatedByString(",").map { cellHumanName in
        return CellName(humanName: cellHumanName)
      }
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
  
  func dependencies() -> [CellName] {
    switch self {
    case .Number(_):          return []
    case .Product(let names): return names
    case .Sum(let names):     return names
    }
  }
  
  func evaluate(env: [CellName:Double]) -> Double {
    switch self {
    case .Number(let x):      return x
    case .Product(let names): return names.map({env[$0]!}).reduce(1,combine:*)
    case .Sum(let names):     return names.map({env[$0]!}).reduce(0,combine:+)
    }
  }
}

// parse input where pipes separate columns and newlines separate rows
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
    for (column, phrase) in line.componentsSeparatedByString("|").enumerate() {
      guard let cell = Cell(textContent: phrase) else { fatalError() }
      let name = CellName(row: row, column: column)
      result[name] = cell
    }
  }

  return result
}

private func buildGraph(cells: [CellName:Cell]) -> AdjacencyListGraph {
  var edges = Array<AdjacencyListGraph.Edge>()
  
  for (name, cell) in cells {
    for dependency in cell.dependencies() {
      edges.append((name.toVertexDescriptor(), dependency.toVertexDescriptor()))
    }
  }
  
  return AdjacencyListGraph(edges: edges)
}

public func evaluate(cells: [CellName:Cell]) -> [CellName:Double] {

  let graph = buildGraph(cells)
  let evalOrder = topologicalSort(graph)
  print("will eval in order: ", evalOrder)
  
  var env = [CellName:Double]()
  cells.keys.forEach { env[$0] = 0.0 }
//  env = cells.map { ($0, 0.0) }
  
  print("START ENV", env)
  for vertexDescriptor in evalOrder {
    // find the Cell
    let cellName = CellName(vertexDescriptor: vertexDescriptor)
    let cell = cells[cellName]!
    print("vd", vertexDescriptor, "name", cellName, "cell", cell)
    
    // evaluate it and store the result in the shadow graph
    env[cellName] = cell.evaluate(env)
  }
  print("FINAL ENV", env)
  
  // convert the shadow graph to an assoc mapping from CellName to Double
  // return it
  return env
}


















