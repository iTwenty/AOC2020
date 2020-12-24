//
//  Puzzle24.swift
//  AOC2020
//
//  Created by jaydeep on 24/12/20.
//

import Foundation

fileprivate struct Tile: Hashable, Equatable {
    var x, y, z: Int

    mutating func move(delta: Tile) {
        x += delta.x
        y += delta.y
        z += delta.z
    }

    func moved(delta: Tile) -> Tile {
        return Tile(x: x + delta.x,y: y + delta.y, z: z + delta.z)
    }

    var neighbours: [Tile] {
        Direction.allCases.map { self.moved(delta: $0.delta) }
    }
}

fileprivate enum Direction: String, CustomStringConvertible, CaseIterable {
    var description: String { self.rawValue }

    case e, se, sw, w, nw, ne

    var delta: Tile {
        switch self {
        case .e: return Tile(x: 1, y: -1, z: 0)
        case .se: return Tile(x: 0, y: -1, z: 1)
        case .sw: return Tile(x: -1, y: 0, z: 1)
        case .w: return Tile(x: -1, y: 1, z: 0)
        case .nw: return Tile(x: 0, y: 1, z: -1)
        case .ne: return Tile(x: 1, y: 0, z: -1)
        }
    }
}

class Puzzle24: Puzzle {
    fileprivate let input: [[Direction]]

    init() {
        input = InputFileReader.readInput(id: "24").map({ (str) -> [Direction] in
            var directions = [Direction]()
            var nextCharConsumed = false
            for (i, c) in zip(str.indices, str) {
                if nextCharConsumed {
                    nextCharConsumed = false
                    continue
                }
                let next = (str.index(after: i) < str.endIndex) ? str[str.index(after: i)] : nil
                if (c == "n" || c == "s"), let n = next, (n == "w" || n == "e") {
                    nextCharConsumed = true
                    directions.append(Direction(rawValue: "\(c)\(n)")!)
                } else {
                    directions.append(Direction(rawValue: "\(c)")!)
                }
            }
            return directions
        })
    }

    func part1() -> String {
        return "\(flipTiles(input).count)"
    }

    func part2() -> String {
        var blackTiles = flipTiles(input)
        for _ in (0..<100) {
            blackTiles = evolve(blackTiles)
        }
        return "\(blackTiles.count)"
    }

    private func flipTiles(_ allDirections: [[Direction]]) -> Set<Tile> {
        var blackTiles = Set<Tile>()
        allDirections.forEach { (directions) in
            var start = Tile(x: 0, y: 0, z: 0)  // Center tile
            directions.forEach { (direction) in
                start.move(delta: direction.delta)
            }
            if blackTiles.contains(start) {
                blackTiles.remove(start)
            } else {
                blackTiles.insert(start)
            }
        }
        return blackTiles
    }

    private func evolve(_ blackTiles: Set<Tile>) -> Set<Tile> {
        var newBlackTiles = Set<Tile>()
        var blackTilesWithNeighbours = Set<Tile>()
        for tile in blackTiles {
            blackTilesWithNeighbours.insert(tile)
            tile.neighbours.forEach { blackTilesWithNeighbours.insert($0) }
        }

        for tile in blackTilesWithNeighbours {
            let count = tile.neighbours.filter { blackTiles.contains($0) }.count
            if blackTiles.contains(tile) && (count == 1 || count == 2) {
                newBlackTiles.insert(tile)
            } else if count == 2 {
                newBlackTiles.insert(tile)
            }
        }
        return newBlackTiles
    }
}
