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
        let ids = possibleSeatIds(maxRows: 128, maxCols: 8).subtracting(seatIds(from: input)).sorted()
        /// If ids contains an entire row worth of seats, that whole row is missing. Our seat is the one that
        /// that is present in ID without any other seats from that row. Can't be bothered to write code to calculate
        /// this. Just looked at ids array manually and figured it out :P
        return "\(ids)"
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

    private func possibleSeatIds(maxRows: Int, maxCols: Int) -> Set<Int> {
        var seatIds = Set<Int>()
        (0..<maxRows).forEach { (row) in
            (0..<maxCols).forEach { (col) in
                seatIds.insert(row * 8 + col)
            }
        }
        return seatIds
    }

    private func seatId(rowCol: RowCol) -> Int {
        rowCol.row * 8 + rowCol.col
    }
}
