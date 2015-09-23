import Foundation

// TODO replace use of Array with an iterator/generator

public protocol Graph {
  typealias Edge
  typealias Vertex: Hashable
  
  mutating func addEdge(u: Vertex, v: Vertex) -> Edge
  mutating func removeEdge(u: Vertex, v: Vertex)
  mutating func removeEdge(e: Edge)
  mutating func addVertex() -> Vertex
  mutating func clearVertex(u: Vertex)
  mutating func removeVertex(u: Vertex) // requires that `clearVertex` has been called first
  // TODO implement me
  //  mutating func removeEdgeIf(...)
  //  mutating func removeOutEdgeIf(...)
  //  mutating func removeInEdgeIf(...)
}

public protocol IncidenceGraph: Graph {
  func outEdges(vertex: Vertex) -> [Edge]
  func outDegree(vertex: Vertex) -> Int
  func source(edge: Edge) -> Vertex
  func target(edge: Edge) -> Vertex
}

public protocol BidirectionalGraph: IncidenceGraph {
  func inEdges(vertex: Vertex) -> [Edge]
  func inDegree(vertex: Vertex) -> Int
  func degree(vertex: Vertex) -> Int
}

public protocol VertexListGraph: Graph {
  func vertices() -> [Vertex]
  func numVertices() -> Int
}

public protocol EdgeListGraph: Graph {
  func edges() -> [Edge]
  func numEdges() -> Int
  func source(edge: Edge) -> Vertex
  func target(edge: Edge) -> Vertex
}

public protocol ReadablePropertyMap {
  typealias Key
  typealias Value
  func get(key: Key) -> Value
}

public protocol WriteablePropertyMap {
  typealias Key
  typealias Value
  mutating func put(key: Key, value: Value)
}

public protocol ReadWritePropertyMap: ReadablePropertyMap, WriteablePropertyMap {
}

public protocol PropertyGraph: Graph {
  typealias VertexProps
  typealias EdgeProps
  subscript(u: Vertex) -> VertexProps { get set }
  subscript(e: Edge) -> EdgeProps { get set }
  
  mutating func addVertex(properties: VertexProps) -> Vertex
  mutating func addEdge(u: Vertex, v: Vertex, properties: EdgeProps) -> Edge
}

public protocol Visitor {
  typealias Vertex
  func discoverVertex(vertex: Vertex)
}
