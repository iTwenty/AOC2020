//
//  Puzzle09.swift
//  AOC2020
//
//  Created by jaydeep on 09/12/20.
//

import Foundation

class Puzzle09: Puzzle {

    let input: [Int]

    init() {
        input = InputFileReader.readInput(id: "09").compactMap(Int.init)
    }

    func part1() -> String {
        let preambleSize = 25
        let index = input[preambleSize...].indices.first { (index) -> Bool in
            return !isValid(index: index, preambleSize: preambleSize)
        }
        return "\(input[index!])"
    }

    func part2() -> String {
        let number = 70639851 // Answer from part1
        for windowSize in (2..<input.count) {
            if let window = window(forSum: number, windowSize: windowSize) {
                let min = window.min()!
                let max = window.max()!
                return "\(min + max)"
            }
        }
        return "Whoops!!"
    }

    private func isValid(index: Int, preambleSize: Int) -> Bool {
        let subInput = input[index-preambleSize..<index]
        for i in subInput {
            for j in subInput {
                if i != j, i + j == input[index] {
                    return true
                }
            }
        }
        return false
    }

    private func window(forSum sum: Int, windowSize: Int) -> ArraySlice<Int>? {
        let subInput = input[0..<input.endIndex - windowSize]
        for i in subInput.indices {
            let window = input[i..<i + windowSize]
            if window.reduce(0, +) == sum {
                return window
            }
        }
        return nil
    }
}
