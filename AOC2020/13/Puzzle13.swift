//
//  Puzzle13.swift
//  AOC2020
//
//  Created by jaydeep on 13/12/20.
//

import Foundation

class Puzzle13: Puzzle {

    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "13")
    }

    func part1() -> String {
        let time = Int(input[0])!
        let busIds = input[1].components(separatedBy: ",").reduce(into: [Int](), { (acc, str) in
            if str != "x" {
                acc.append(Int(str)!)
            }
        })
        var currentMinTime = Int.max
        var currentMinBusId = busIds[0]
        for busId in busIds {
            var t = busId
            while t < time {
                t += busId
            }
            if t < currentMinTime {
                currentMinTime = t
                currentMinBusId = busId
            }
        }
        let waitMinutes = currentMinTime - time
        return "\(currentMinBusId * waitMinutes)"
    }

    // Works but too slow for challenge input.
    func part2_slow() -> String {
        let busIdsWithX = input[1].components(separatedBy: ",")
        var offsets = [Int64]()
        var busIds = [Int64]()
        for (index, busIdOrx) in busIdsWithX.enumerated() {
            if let busId = Int64(busIdOrx) {
                offsets.append(Int64(index))
                busIds.append(busId)
            }
        }
        let max = busIds.max()!
        let maxIndex = offsets[busIds.firstIndex(of: max)!]
        var current = max - maxIndex
        while true {
            let possibleTimes = offsets.map { Int64($0) + current }
            var found = true
            for (index, possibleTime) in possibleTimes.enumerated() {
                if possibleTime % busIds[index] != 0 {
                    found = false
                    break
                }
                found = true
            }
            if found == true {
                return "\(possibleTimes[0])"
            } else {
                current += max
            }
        }
    }

    func part2() -> String {
        let busIdsWithX = input[1].components(separatedBy: ",")
        let hack = busIdsWithX.enumerated().reduce(into: [String]()) { (acc, enumeration) in
            let (idx, busIdOrX) = enumeration
            if let busId = Int(busIdOrX) {
                acc.append("t + \(idx) mod \(busId) = 0")
            }
        }.joined(separator: ", ")
        return "Paste \"\(hack)\" into wolfram alpha to get the answer"
    }
}
