//
//  Puzzle03.swift
//  AOC2020
//
//  Created by jaydeep on 03/12/20.
//

import Foundation

class Puzzle03: Puzzle {

    typealias Slope = (right: Int, down: Int)

    let map: [[Character]]
    let width: Int

    init() {
        map = InputFileReader.readInput(id: "03").map { Array($0) }
        width = map[0].count
    }

    func part1() -> String {
        let count = treeCount(slope: (3, 1))
        return "\(count)"
    }

    func part2() -> String {
        let slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        let count = slopes.reduce(1) { (acc, slope) -> Int in
            acc * treeCount(slope: slope)
        }
        return "\(count)"
    }

    private func treeCount(slope: Slope) -> Int {
        var treeCount = 0
        var x = slope.right
        for y in stride(from: slope.down, to: map.count, by: slope.down) {
            if map[y][x % width] == "#" {
                treeCount = treeCount + 1
            }
            x = x + slope.right
        }
        return treeCount
    }
}
