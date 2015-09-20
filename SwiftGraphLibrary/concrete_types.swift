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

public struct AdjacencyListGraph: IncidenceGraph, VertexListGraph {
  public typealias Vertex = Int
  public typealias Edge = (Vertex, Vertex)
  
  private var adjacencyLists = [Vertex:[Vertex]]()
  
  public init(edges: [Edge]) {
    // TODO make more concise
    for (u,v) in edges {
      
      // connect from u to v
      if var targets = adjacencyLists[u] {
        targets.append(v)
        adjacencyLists[u] = targets
      } else {
        adjacencyLists[u] = [v]
      }
      
      // create an empty list for v, if necessary
      if adjacencyLists[v] == nil {
        adjacencyLists[v] = []
      }
    }
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
