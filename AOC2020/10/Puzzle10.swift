//
//  Puzzle10.swift
//  AOC2020
//
//  Created by jaydeep on 10/12/20.
//

import Foundation

class Puzzle10: Puzzle {

    var adapters: [Int]

    init() {
        adapters = InputFileReader.readInput(id: "10").compactMap(Int.init).sorted()
        adapters.insert(0, at: 0) // Add charging port
        adapters.append(adapters.last! + 3) // Add own device
    }

    func part1() -> String {
        let joltageDiffs = zip(adapters.dropFirst(), adapters).map { $0.0 - $0.1 }
        let (onesCount, threesCount) = joltageDiffs.reduce((0, 0)) { (acc, current) in
            if current == 1 { return (acc.0 + 1, acc.1) }
            if current == 3 { return (acc.0, acc.1 + 1) }
            return acc
        }
        return "\(onesCount * threesCount)"
    }

    func part2() -> String {
        return "\(getCount(from: 0))"
    }

    private var cache = [Int: Int]()
    private func getCount(from index: Int) -> Int {
        var sum = 0
        if let cachedCount = cache[index] {
            return cachedCount
        }
        if index == adapters.count - 1 {
            return 1
        }
        for i in (index+1..<index+4) {
            if i >= adapters.count { continue }
            if adapters[i] - adapters[index] <= 3 {
                let count = getCount(from: i)
                sum += count
                cache[i] = count
            }
        }
        return sum
    }
}
