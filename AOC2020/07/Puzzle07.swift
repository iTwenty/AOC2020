//
//  Puzzle07.swift
//  AOC2020
//
//  Created by jaydeep on 07/12/20.
//

import Foundation

class Puzzle07: Puzzle {

    let bagsGraph: Graph<String>

    init() {
        bagsGraph = Puzzle07.graph(from: InputFileReader.readInput(id: "07"))
    }

    func part1() -> String {
        var count = 0
        bagsGraph.vertices.forEach { (vertex) in
            bagsGraph.bfs(from: vertex) { (visitingVertex) in
                if visitingVertex == "shiny gold" {
                    count += 1
                }
            }
        }
        return "\(count - 1)" // -1 to remove shiny gold vertex itself
    }

    func part2() -> String {
        let totalBagsCount = bagCount(vertex: "shiny gold") - 1 // -1 to remove shiny gold itself
        return "\(totalBagsCount)"
    }

    private func bagCount(vertex: String) -> Int {
        var count = 1
        bagsGraph.edges(for: vertex).forEach { (edge) in
            count += (edge.weight * bagCount(vertex: bagsGraph.vertices[edge.dstIndex]))
        }
        return count
    }

    private static func graph(from input: [String]) -> Graph<String> {
        var graphEdges = [[(String, Int)]]()
        var vertices = [String]()
        input.forEach { (str) in
            let bagWithContents = str.components(separatedBy: " bags contain ")
                .flatMap { $0.components(separatedBy: ", ") }
            vertices.append(bagWithContents[0])
            var graphEdgesForCurrentVertex = [(String, Int)]()
            bagWithContents.dropFirst().forEach { (str) in
                let bagContents = str.components(separatedBy: " ")
                if let count = Int(bagContents[0]) {
                    let color = "\(bagContents[1]) \(bagContents[2])"
                    graphEdgesForCurrentVertex.append((color, count))
                }
            }
            graphEdges.append(graphEdgesForCurrentVertex)
        }
        let graph = Graph<String>(vertices: vertices)
        for (index, src) in vertices.enumerated() {
            let edges = graphEdges[index]
            for (dst, weight) in edges {
                graph.addEdge(from: src, to: dst, weight: weight)
            }
        }
        return graph
    }
}
