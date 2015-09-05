import Foundation

typealias Vertex = Int

typealias Edge = (Vertex, Vertex)
func src(edge: Edge) -> Vertex { return edge.0 }
func tgt(edge: Edge) -> Vertex { return edge.1 }


struct AdjacencyListGraph {
  private let adjacencyLists: [Vertex:[Vertex]]
  
  func vertices() -> [Vertex] {
    return Array(adjacencyLists.keys)
  }
  
  func numVertices() -> Int {
    return adjacencyLists.count
  }
  
  func outEdges(vertex: Vertex) -> [Edge] {
    let infiniteSource = anyGenerator { vertex }
    let targets = adjacencyLists[vertex]!
    return Array(zip(infiniteSource, targets))
  }
  
  func outDegree(vertex: Vertex) -> Int {
    return adjacencyLists[vertex]!.count
  }
}

let lists = [
  1: [2, 3],
  2: [1],
  3: [1, 4],
  4: [3, 5],
  5: [4]
]
let g = AdjacencyListGraph(adjacencyLists: lists)

print(g.adjacencyLists)

print(g.outEdges(1))

func breadthFirstSearch(graph: AdjacencyListGraph, visitor: (Vertex -> Void)) {
  if graph.numVertices() == 0 {
    return
  }
  
  var seen = Set<Vertex>()
  var queue = [Vertex]()
  let firstVertex = graph.vertices()[0]
  print("starting with vertex \(firstVertex)")
  queue.append(firstVertex)
  while !queue.isEmpty {
    let v = queue.removeFirst()
    if seen.contains(v) {
      continue
    }
    queue.appendContentsOf(graph.outEdges(v).map(tgt))
    visitor(v)
    seen.insert(v)
  }
  print("done")
}

func testVisitor(v: Vertex) -> Void {
  print("got vertex '\(v)'")
}

breadthFirstSearch(g, visitor: testVisitor)
