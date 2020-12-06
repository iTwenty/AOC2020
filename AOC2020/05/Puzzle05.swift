//
//  Puzzle05.swift
//  AOC2020
//
//  Created by jaydeep on 05/12/20.
//

import Foundation

class Puzzle05: Puzzle {

    typealias RowCol = (row: Int, col: Int)

    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "05")
    }

    func part1() -> String {
        let max = seatIds(from: input).max()!
        return "\(max)"
    }

    func part2() -> String {
        let ids = seatIds(from: input).sorted()
        for (index, seatId) in ids.enumerated() {
            if ids[index + 1] != seatId + 1 {
                return "\(seatId + 1)"
            }
        }
        return "Could not find own seat ID!!!"
    }

    private func seatIds(from input: [String]) -> [Int] {
        let binaryStrings = input.map { (str) -> String in
            let bitsArray = str.map { (c) -> Character in
                (c == "F" || c == "L") ? "0" : "1"
            }
            return String(bitsArray)
        }
        let rowCols = binaryStrings.map { (str) -> RowCol in
            let rowBinary = str.dropLast(3)
            let colBinary = str.dropFirst(7)
            return (Int(rowBinary, radix: 2)!, Int(colBinary, radix: 2)!)
        }

        return rowCols.map(seatId)
    }

    private func seatId(rowCol: RowCol) -> Int {
        rowCol.row * 8 + rowCol.col
    }
}
