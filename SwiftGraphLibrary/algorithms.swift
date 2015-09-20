import Foundation

public func depthFirstSearch<
  G: IncidenceGraph,
  C: ReadWritePropertyMap,
  V: Visitor
  where G.Vertex == V.Vertex,
        C.Key    == G.Vertex,
        C.Value  == VertexColorType
  >
  (graph: G, startVertex: G.Vertex, inout colorMap: C, visitor: V) {
  
  for v in graph.outEdges(startVertex).map(graph.target) {
    switch colorMap.get(v) {
    case .White:
      colorMap.put(v, value: .Gray)
      depthFirstSearch(graph, startVertex: v, colorMap: &colorMap, visitor: visitor)
    case .Gray:
      continue
    case .Black:
      continue
    }
  }
  
  visitor.discoverVertex(startVertex)
  colorMap.put(startVertex, value: .Black)
}

class AccumulatorVisitor<Vertex>: Visitor {
  var accumulator = [Vertex]()
  func discoverVertex(vertex: Vertex) {
    accumulator.append(vertex)
  }
}

public func topologicalSort<
  G: protocol<IncidenceGraph, VertexListGraph>
  >
  (graph: G) -> [G.Vertex] {
    
    if graph.numVertices() == 0 {
      return []
    }
    
    // find the root vertices
    var roots = Set<G.Vertex>(graph.vertices())
    for u in graph.vertices() {
      for v in graph.outEdges(u).map(graph.target) {
        if roots.contains(v) {
          roots.remove(v)
        }
      }
    }
    assert(!roots.isEmpty, "not a DAG")
    
    // important, we must initialize the color map outside of DFS so that we can share
    // it amongst each DFS call for each root. Boost Graph Library solved this by having
    // two variants of DFS, depth_first_search and depth_first_visit, which did and did not
    // initialize the color map, respectively.
    var colorMap = DictionaryPropertyMap<G.Vertex, VertexColorType>()
    for u in graph.vertices() {
      colorMap.put(u, value: .White)
    }
    
    // walk the graph
    let visitor = AccumulatorVisitor<G.Vertex>()
    for root in roots {
      depthFirstSearch(graph, startVertex: root, colorMap: &colorMap, visitor: visitor)
    }
    return visitor.accumulator
}

public func breadthFirstSearch<
  G: protocol<IncidenceGraph, VertexListGraph>,
  C: ReadWritePropertyMap,
  V: Visitor
  where G.Vertex == V.Vertex,
        C.Key    == G.Vertex,
        C.Value  == VertexColorType
  >
  (graph: G, startVertex: G.Vertex, var colorMap: C, visitor: V) {
    if graph.numVertices() == 0 {
      return
    }
    
    for vertex in graph.vertices() {
      colorMap.put(vertex, value: .White)
    }
    
    var queue = Array<G.Vertex>()
    colorMap.put(startVertex, value: .Gray)
    visitor.discoverVertex(startVertex)
    queue.append(startVertex)
    
    while !queue.isEmpty {
      let u = queue.removeFirst()
      for v in graph.outEdges(u).map(graph.target) {
        switch colorMap.get(v) {
        case .White:
          colorMap.put(v, value: .Gray)
          visitor.discoverVertex(v)
          queue.append(v)
        case .Gray:
          continue
        case .Black:
          continue
        }
      }
      colorMap.put(u, value: .Black)
    }
    print("done")
}
