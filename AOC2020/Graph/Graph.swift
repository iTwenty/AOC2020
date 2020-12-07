//
//  Graph.swift
//  AOC2020
//
//  Created by jaydeep on 07/12/20.
//

import Foundation

class Graph<V: Hashable> {

    var vertices = [V]()
    var edges = [[Edge]]()

    init(vertices: [V]) {
        vertices.forEach(addVertex)
    }

    func addVertex(_ vertex: V) {
        vertices.append(vertex)
        edges.append([])
    }

    func addEdge(from src: V, to dst: V, weight: Int) {
        guard let srcIndex = vertices.firstIndex(of: src), let dstIndex = vertices.firstIndex(of: dst) else {
            print("Either \(src) or \(dst) (or both) not added to graph yet!!!")
            return
        }
        let edge = Edge(srcIndex: srcIndex, dstIndex: dstIndex, weight: weight)
        edges[srcIndex].append(edge)
    }

    func bfs(from start: V, visit: (V) -> Void) {
        visit(start)
        var visited: Set<V> = [start]
        var neighbours = edges(for: start)

        while let neighbour = neighbours.popLast() {
            let vertex = vertices[neighbour.dstIndex]
            if !visited.contains(vertex) {
                visit(vertex)
                visited.insert(vertex)
            }
            neighbours.insert(contentsOf: edges(for: vertex), at: 0)
        }
    }

    func edges(for vertex: V) -> [Edge] {
        guard let vertexIndex = vertices.firstIndex(of: vertex) else { return [] }
        return edges[vertexIndex]
    }
}
