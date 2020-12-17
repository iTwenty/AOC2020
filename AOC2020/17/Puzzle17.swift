//
//  Puzzle17.swift
//  AOC2020
//
//  Created by jaydeep on 17/12/20.
//

import Foundation

struct Point3: Equatable, Hashable {
    let x, y, z: Int

    init(_ x: Int, _ y: Int, _ z: Int) {
        (self.x, self.y, self.z) = (x, y, z)
    }

    func neighbours() -> [Point3] {
        var neighbours = [Point3]()
        [-1,0,1].forEach { (d1) in
            [-1,0,1].forEach { (d2) in
                [-1,0,1].forEach { (d3) in
                    if !(d1 == 0 && d2 == 0 && d3 == 0) {
                        neighbours.append(Point3(x + d1, y + d2, z + d3))
                    }
                }
            }
        }
        return neighbours
    }
}

struct Point4: Equatable, Hashable {
    let x, y, z, w: Int

    init(_ x: Int, _ y: Int, _ z: Int, _ w: Int) {
        (self.x, self.y, self.z, self.w) = (x, y, z, w)
    }

    func neighbours() -> [Point4] {
        var neighbours = [Point4]()
        [-1,0,1].forEach { (d1) in
            [-1,0,1].forEach { (d2) in
                [-1,0,1].forEach { (d3) in
                    [-1,0,1].forEach { (d4) in
                        if !(d1 == 0 && d2 == 0 && d3 == 0 && d4 == 0) {
                            neighbours.append(Point4(x + d1, y + d2, z + d3, w + d4))
                        }
                    }
                }
            }
        }
        return neighbours
    }
}

class Puzzle17: Puzzle {
    let input: [[Character]]

    init() {
        input = InputFileReader.readInput(id: "17").map(Array.init)
    }

    func part1() -> String {
        var grid = [Point3: Character]()
        input.enumerated().forEach { (y, line) in
            line.enumerated().forEach { (x, state) in
                grid[Point3(x, y, 0)] = state
            }
        }

        for _ in (0..<6) {
            var newGrid = [Point3: Character]()
            let allPoints = grid.keys
            let allXs = allPoints.map(\.x)
            let allYs = allPoints.map(\.y)
            let allZs = allPoints.map(\.z)
            let newMinX = allXs.min()! - 1
            let newMaxX = allXs.max()! + 1
            let newMinY = allYs.min()! - 1
            let newMaxY = allXs.max()! + 1
            let newMinZ = allZs.min()! - 1
            let newMaxZ = allZs.max()! + 1
            for x in (newMinX...newMaxX) {
                for y in (newMinY...newMaxY) {
                    for z in (newMinZ...newMaxZ) {
                        let cube = Point3(x, y, z)
                        newGrid[cube] = newState(grid[cube, default: "."], neighbours: cube.neighbours(), grid: grid)
                    }
                }
            }
            grid = newGrid
        }

        let activeCount = grid.values.filter { $0 == "#" }.count
        return "\(activeCount)"
    }

    func part2() -> String {
        var grid = [Point4: Character]()
        input.enumerated().forEach { (y, line) in
            line.enumerated().forEach { (x, state) in
                grid[Point4(x, y, 0, 0)] = state
            }
        }

        for _ in (0..<6) {
            var newGrid = [Point4: Character]()
            let allPoints = grid.keys
            let allXs = allPoints.map(\.x)
            let allYs = allPoints.map(\.y)
            let allZs = allPoints.map(\.z)
            let allWs = allPoints.map(\.w)
            let newMinX = allXs.min()! - 1
            let newMaxX = allXs.max()! + 1
            let newMinY = allYs.min()! - 1
            let newMaxY = allXs.max()! + 1
            let newMinZ = allZs.min()! - 1
            let newMaxZ = allZs.max()! + 1
            let newMinW = allWs.min()! - 1
            let newMaxW = allWs.max()! + 1
            for x in (newMinX...newMaxX) {
                for y in (newMinY...newMaxY) {
                    for z in (newMinZ...newMaxZ) {
                        for w in (newMinW...newMaxW) {
                            let cube = Point4(x, y, z, w)
                            newGrid[cube] = newState(grid[cube, default: "."], neighbours: cube.neighbours(), grid: grid)
                        }
                    }
                }
            }
            grid = newGrid
        }

        let activeCount = grid.values.filter { $0 == "#" }.count
        return "\(activeCount)"
    }

    private func newState<T: Hashable>(_ currentState: Character, neighbours: [T], grid: [T: Character]) -> Character {
        let active = neighbours.filter { grid[$0, default: "."] == "#" }
        switch currentState {
        case "#": return (active.count == 2 || active.count == 3) ? "#" : "."
        case ".": return active.count == 3 ? "#" : "."
        default: return currentState
        }
    }
}
