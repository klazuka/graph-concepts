import Foundation

class MyVisitor: Visitor {
  func discoverVertex(vertex: Int) {
    print("got vertex '\(vertex)'")
  }
}

struct AdjacencyListGraph: IncidenceGraph, VertexListGraph {
  typealias Vertex = Int
  typealias Edge = (Vertex, Vertex)

  private let adjacencyLists: [Vertex:[Vertex]]
  
  func src(edge: Edge) -> Vertex { return edge.0 }
  func tgt(edge: Edge) -> Vertex { return edge.1 }
  
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

breadthFirstSearch(g, visitor: MyVisitor())
