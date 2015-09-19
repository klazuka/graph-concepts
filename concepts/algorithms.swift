import Foundation

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
