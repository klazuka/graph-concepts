import Foundation

// TODO remoove me
class DummyVisitor<Vertex>: Visitor {
  func discoverVertex(vertex: Vertex) {}
}

func depthFirstSearch<
  G: IncidenceGraph,
  C: ReadWritePropertyMap,
  V: Visitor
  where G.Vertex == V.Vertex,
        C.Key == G.Vertex,
        C.Value == VertexColorType
  >
  (graph: G, startVertex: G.Vertex, inout colorMap: C, visitor: V)
  -> [G.Vertex] // TODO get rid of return value in-lieu of Visitor
{
  var rest = Array<G.Vertex>()
  
  for v in graph.outEdges(startVertex).map(graph.target) {
    switch colorMap.get(v) {
    case .White:
      colorMap.put(v, value: .Gray)
      rest.appendContentsOf(depthFirstSearch(graph, startVertex: v, colorMap: &colorMap, visitor: visitor))
    case .Gray:
      continue
    case .Black:
      continue
    }
  }
  
  rest.append(startVertex)
  visitor.discoverVertex(startVertex)
  colorMap.put(startVertex, value: .Black)
  
  return rest
}


func topologicalSort<
  G: protocol<IncidenceGraph, VertexListGraph>
  >
  (graph: G) -> [G.Vertex] {
    
    if graph.numVertices() == 0 {
      return []
    }
    
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
    
    let visitor = DummyVisitor<G.Vertex>()
    
    var result = Array<G.Vertex>()
    for root in roots {
      result.appendContentsOf(depthFirstSearch(graph, startVertex: root, colorMap: &colorMap, visitor: visitor))
    }
    
    return result
}

func breadthFirstSearch<
  G: protocol<IncidenceGraph, VertexListGraph>,
  C: ReadWritePropertyMap,
  V: Visitor
  where G.Vertex == V.Vertex,
        C.Key == G.Vertex,
        C.Value == VertexColorType
  >
  (graph: G, startVertex: G.Vertex, var colorMap: C, visitor: V) {
    if graph.numVertices() == 0 {
      return
    }
    
    for vertex in g.vertices() {
      // TODO why do I need to force cast here? (Int vs G.Vertex)
      colorMap.put(vertex as! G.Vertex, value: VertexColorType.White)
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
