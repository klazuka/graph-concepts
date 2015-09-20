import XCTest
@testable import SwiftGraphLibrary

class TraversalTests: XCTestCase {
  
  func testDepthFirstSearch() {
    let edges = [
      (1,3),
      (1,4),
      (1,5),
      (2,5),
      (2,6),
      (3,10),
      (4,7),
      (4,8),
      (5,8),
      (6,9),
      (6,11),
      (7,10),
      (9,11),
      (9,12),
    ]
    let g = AdjacencyListGraph(edges: edges)
    
    let visitor = AccumulatorVisitor<AdjacencyListGraph.Vertex>()
    var colorMap = DictionaryPropertyMap<AdjacencyListGraph.Vertex, VertexColorType>()
    g.vertices().forEach { colorMap.put($0, value: .White) }
    depthFirstSearch(g, startVertex: 1, colorMap: &colorMap, visitor: visitor)
    // there are many valid DFS traversals of this graph,
    // but based on the current impl, it will always match the following
    // TODO: make the test more robust.
    XCTAssertEqual(visitor.accumulator, [10, 3, 7, 8, 4, 5, 1])
  }
  
  func testTopologicalSort() {
    let edges = [
      (1,3),
      (1,4),
      (1,5),
      (2,5),
      (2,6),
      (3,10),
      (4,7),
      (4,8),
      (5,8),
      (6,9),
      (6,11),
      (7,10),
      (9,11),
      (9,12),
    ]
    let g = AdjacencyListGraph(edges: edges)
    
    let topo = topologicalSort(g)
    // there are many valid topological orderings of this graph,
    // but based on the current impl, it will always match the following
    // TODO: make the test more robust.
    XCTAssertEqual(topo, [8, 5, 11, 12, 9, 6, 2, 10, 3, 7, 4, 1])
  }
  
  func testBreadthFirstSearch() {
    // poor-man's undirected graph until I can implement it properly
    let edges = [
      (1,2), (2,1),
      (1,3), (3,1),
      (1,6), (6,1),
      (2,3), (3,2),
      (3,4), (4,3),
      (4,5), (5,4),
      (5,6), (6,5),
    ]
    
    let g = AdjacencyListGraph(edges: edges)
    let start = g.findVertex(2)!
    let visitor = AccumulatorVisitor<AdjacencyListGraph.Vertex>()
    breadthFirstSearch(g, startVertex: start, colorMap: DictionaryPropertyMap(), visitor: visitor)
    // there are many valid BFS traversals of this graph starting from vertex 2,
    // but based on the current impl, it will always match the following
    // TODO: make the test more robust
    XCTAssertEqual(visitor.accumulator, [2, 1, 3, 6, 4, 5])
  }
  
}
