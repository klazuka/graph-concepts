import Foundation

public enum VertexColorType {
  case White, Gray, Black
}

// a `ReadWritePropertyMap` adapter for Swift's Dictionary type
public struct DictionaryPropertyMap<Key: Hashable, Value>: ReadWritePropertyMap {
  private var dict: [Key:Value]
  
  public init() {
    self.dict = [Key:Value]()
  }
  
  public init(dictionary: [Key:Value]) {
    self.dict = dictionary
  }
  
  public func get(key: Key) -> Value {
    return dict[key]!
  }
  
  public mutating func put(key: Key, value: Value) {
    dict[key] = value
  }
}


public class PrintVisitor: Visitor {
  public init() {
  }
  public func discoverVertex(vertex: Int) {
    print("got vertex '\(vertex)'")
  }
}

public struct NoProperty {
  // an empty struct for Vertex- and Edge-Properties
  init() {}
}

// TODO break apart into Extensions based on Protocol conformance

public struct AdjacencyListGraph<
  VertexProperties, // TODO can Swift provide a default arg for a generic type parameter list?
  EdgeProperties
  > : MutablePropertyGraph, IncidenceGraph, VertexListGraph {
  
  public typealias Vertex = Int
  public typealias Edge = (Vertex, Vertex)
  
  private var adjacencyLists = [Vertex:[Vertex]]()
  private var vertexProperties = [Vertex:VertexProperties!]()
  private var edgeProperties = [Vertex:[EdgeProperties!]]()
  
  public init() {
    adjacencyLists = [:]
    vertexProperties = [:]
    edgeProperties = [:]
  }

  public init(numVertices: Int) {
    for i in 0..<numVertices {
      adjacencyLists[i] = []
      vertexProperties[i] = nil
      edgeProperties[i] = []
    }
  }
  
  public init(edges: [Edge], numVertices: Int) {
    self.init(numVertices: numVertices)
    for (u,v) in edges {
      addEdge(u, v: v)
    }
  }
  
  
  
  public mutating func addEdge(u: Vertex, v: Vertex) -> Edge {
    return implAddEdge(u, v: v, properties: nil)
  }
  
  public mutating func removeEdge(u: Vertex, v: Vertex) {
    // TODO
    fatalError()
  }
  public mutating func removeEdge(e: Edge) {
    // TODO
    fatalError()
  }
  
  public mutating func addVertex() -> Vertex {
    return implAddVertex(nil)
  }
  
  public mutating func clearVertex(u: Vertex) {
    // TODO
    fatalError()
  }
  public mutating func removeVertex(u: Vertex) {
    // TODO
    fatalError()
  }
  
  // internal impl of MutablePropertyGraph interface to hide the Optionals
  private mutating func implAddVertex(properties: VertexProperties?) -> Vertex {
    let u = adjacencyLists.count
    adjacencyLists[u] = []
    if let props = properties {
      vertexProperties[u] = props
    }
    edgeProperties[u] = []
    return u
  }
  
  private mutating func implAddEdge(u: Vertex, v: Vertex, properties: EdgeProperties?) -> Edge {
    guard u >= 0 && u < adjacencyLists.count else { fatalError("invalid source vertex") }
    guard v >= 0 && v < adjacencyLists.count else { fatalError("invalid target vertex") }
    
    // TODO handle undirected graphs
    
    // connect from u to v
    var targets = adjacencyLists[u]!
    targets.append(v)
    adjacencyLists[u] = targets
    
    if let props = properties {
      edgeProperties[u]![targets.endIndex.predecessor()] = props
    }
    
    return (u,v)
  }
  
  // MutablePropertyGraph
  public mutating func addVertex(properties: VertexProperties) -> Vertex {
    return implAddVertex(properties)
  }
  
  public mutating func addEdge(u: Vertex, v: Vertex, properties: EdgeProperties) -> Edge {
    return implAddEdge(u, v: v, properties: properties)
  }

  // PropertyGraph
  // TODO provide a custom subscript operator instead of get/put
  // TODO how to handle absence of vertex/edge properties?
  public typealias VertexProps = VertexProperties
  public func get(u: Vertex) -> VertexProperties {
    return vertexProperties[u]!
  }
  public mutating func put(u: Vertex, properties: VertexProperties) {
    vertexProperties[u] = properties
  }
  
  public typealias EdgeProps = EdgeProperties
  public func get(e: Edge) -> EdgeProperties {
    let (u,v) = e
    let list = adjacencyLists[u]!
    let props = edgeProperties[u]!
    return props[list.indexOf(v)!]
  }
  mutating public func put(e: Edge, properties: EdgeProperties) {
    let (u,v) = e
    let list = adjacencyLists[u]!
    var props = edgeProperties[u]!
    props[list.indexOf(v)!] = properties
    edgeProperties[u] = props
  }
  
  
  public func source(edge: Edge) -> Vertex { return edge.0 }
  public func target(edge: Edge) -> Vertex { return edge.1 }
  
  public func vertices() -> [Vertex] {
    return Array(adjacencyLists.keys)
  }
  
  public func numVertices() -> Int {
    return adjacencyLists.count
  }
  
  public func outEdges(vertex: Vertex) -> [Edge] {
    let infiniteSource = anyGenerator { vertex }
    let targets = adjacencyLists[vertex]!
    return Array(zip(infiniteSource, targets))
  }
  
  public func outDegree(vertex: Vertex) -> Int {
    return adjacencyLists[vertex]!.count
  }
}

public extension AdjacencyListGraph {
  public func findVertex(name: Int) -> Vertex? {
    guard let idx = adjacencyLists.keys.indexOf(name) else { return nil }
    return adjacencyLists.keys[idx]
  }
}
