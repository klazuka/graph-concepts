
import Foundation

// TODO replace use of Array with an iterator/generator

protocol Graph {
  typealias Edge
  typealias Vertex: Hashable
}

protocol IncidenceGraph: Graph {
  func outEdges(vertex: Vertex) -> [Edge]
  func outDegree(vertex: Vertex) -> Int
  func source(edge: Edge) -> Vertex
  func target(edge: Edge) -> Vertex
}

protocol BidirectionalGraph: IncidenceGraph {
  func inEdges(vertex: Vertex) -> [Edge]
  func inDegree(vertex: Vertex) -> Int
  func degree(vertex: Vertex) -> Int
}

protocol VertexListGraph: Graph {
  func vertices() -> [Vertex]
  func numVertices() -> Int
}

protocol EdgeListGraph: Graph {
  func edges() -> [Edge]
  func numEdges() -> Int
  func source(edge: Edge) -> Vertex
  func target(edge: Edge) -> Vertex
}




protocol ReadablePropertyMap {
  typealias Key
  typealias Value
  func get(key: Key) -> Value
}


//protocol PropertyTag {
//  typealias Kind // ????
//}

protocol PropertyGraph: Graph {
  typealias PropertyMap: ReadablePropertyMap
  func get(property: PropertyMap.Key) -> PropertyMap.Value
}











protocol Visitor {
  typealias Vertex
  func discoverVertex(vertex: Vertex)
}

