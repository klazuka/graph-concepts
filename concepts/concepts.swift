
import Foundation

protocol Graph {
  typealias Edge
  typealias Vertex: Hashable
  func src(edge: Edge) -> Vertex
  func tgt(edge: Edge) -> Vertex
}

protocol IncidenceGraph: Graph {
  func outEdges(vertex: Vertex) -> [Edge]
  func outDegree(vertex: Vertex) -> Int
}

protocol VertexListGraph {
  typealias Vertex
  func vertices() -> [Vertex]
  func numVertices() -> Int
}

protocol Visitor {
  typealias Vertex
  func discoverVertex(vertex: Vertex)
}

