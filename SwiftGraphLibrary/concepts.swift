import Foundation

// TODO replace use of Array with an iterator/generator

public protocol Graph {
  typealias Edge
  typealias Vertex: Hashable
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

//public protocol PropertyGraph: Graph {
//  typealias PropertyMap: ReadablePropertyMap
//  func get(property: PropertyMap.Key) -> PropertyMap.Value
//}

public protocol Visitor {
  typealias Vertex
  func discoverVertex(vertex: Vertex)
}
