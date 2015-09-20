import Foundation
import SwiftGraphLibrary

func runGraphDemo() {
  
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
  
  print("Running topological sort")
  let topo = topologicalSort(g)
  print("topo: ", topo)
  
  print("Running BFS example")
  let start = g.findVertex(1)!
  breadthFirstSearch(g, startVertex: start, colorMap: DictionaryPropertyMap(), visitor: PrintVisitor())
}

