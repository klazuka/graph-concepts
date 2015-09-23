import Foundation

public typealias CellGraph = AdjacencyListGraph<CellVertex,NoProperty>

public typealias CellName = String // e.g. "A1", "A2", "B1", etc.

func makeCellName(row row: Int, column: Int) -> CellName {
  let columnLetter = Character(UnicodeScalar(0x41 + column))
  return "\(columnLetter)\(row+1)"
}

func rowAndColumnFromCellName(name: CellName) -> (Int,Int) {
  // note: only supports columns A-Z, rows 1-9
  assert(name.characters.count == 2)
  guard let columnLetter = name.utf8.first else { fatalError() }
  let column = Int(columnLetter - 0x41)
  let rowNumText = name.utf8[name.utf8.startIndex.successor()] - 0x30
  let row = Int(rowNumText) - 1
  return (row, column)
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
      // TODO strip whitespace
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

public func ==(lhs: Cell, rhs: Cell) -> Bool {
  switch (lhs,rhs) {
  case let (.Number(x), .Number(y)) where x == y: return true
  case let (.Product(a), .Product(b)) where a == b: return true
  case let (.Sum(a), .Sum(b)) where a == b: return true
  default: return false
  }
}
extension Cell: Equatable {}

public typealias ParsedCells = [(row: Int, column: Int, formula: Cell)]

// parse input where pipes separate columns and newlines separate rows
// example input: "100|42\n=PRODUCT(A1,B1)|=SUM(A2,B1)"
// corresponds to
//
//      | A                | B
//   ---+------------------+--------------
//    1 | 100              | 42
//    2 | =PRODUCT(A1, B1) | =SUM(A2, B1)
//
public func parseText(input: String) -> ParsedCells {
  var result = ParsedCells()
  
  for (row, line) in input.componentsSeparatedByString("\n").enumerate() {
    for (column, phrase) in line.componentsSeparatedByString("|").enumerate() {
      guard let formula = Cell(textContent: phrase) else { fatalError() }
      result.append((row: row, column: column, formula: formula))
    }
  }

  return result
}

public struct CellVertex {
  let name: String
  let row: Int
  let column: Int
  let formula: Cell
}

public func buildGraph(cells: ParsedCells) -> CellGraph {
  
  var graph = CellGraph()
  var mapping: [CellName:CellGraph.Vertex] = [:]
  
  // Create a vertex for each spreadsheet cell
  for (row, column, formula) in cells {
    let name = makeCellName(row: row, column: column)
    let u = graph.addVertex(CellVertex(name: name, row: row, column: column, formula: formula))
    mapping[name] = u
  }
  
  // Connect the vertices based on data-flow between cells
  for (row, column, formula) in cells {
    let name = makeCellName(row: row, column: column)
    for dependency in formula.dependencies() {
      let (u,v) = (mapping[name]!, mapping[dependency]!)
      graph.addEdge(u, v: v)
    }
  }
  
  return graph
}

public func evaluate(graph: CellGraph) -> [CellName:Double] {

  let evalOrder = topologicalSort(graph)
  print("will eval in order: ", evalOrder)
  
  var env = [CellName:Double]()
  graph.vertices().forEach { vertexDescriptor in
    let name = graph[vertexDescriptor].name
    env[name] = 0.0
  }
  
  print("START ENV", env)
  for vertexDescriptor in evalOrder {
    // find the Cell and its formula
    let cellName = graph[vertexDescriptor].name
    let formula = graph[vertexDescriptor].formula
    
    // evaluate it and store the result in the environment
    env[cellName] = formula.evaluate(env)
  }
  print("FINAL ENV", env)
  
  return env
}
