import Foundation

func breadthFirstSearch<
  G: protocol<IncidenceGraph, VertexListGraph>,
  V: Visitor
  where G.Vertex == V.Vertex
  >
  (graph: G, visitor: V) {
    if graph.numVertices() == 0 {
      return
    }
    
    var seen = Set<G.Vertex>()
    var queue = Array<G.Vertex>()
    let firstVertex = graph.vertices()[0]
    print("starting with vertex \(firstVertex)")
    queue.append(firstVertex)
    while !queue.isEmpty {
      let v = queue.removeFirst()
      if seen.contains(v) {
        continue
      }
      let others = graph.outEdges(v).map { graph.tgt($0) }
      queue.appendContentsOf(others)
      visitor.discoverVertex(v)
      seen.insert(v)
    }
    print("done")
}
