//
//  Puzzle11.swift
//  AOC2020
//
//  Created by jaydeep on 11/12/20.
//

import Foundation

enum Seat: Character {
    case empty = "L"
    case occupied = "#"
    case floor = "."

    func newState(neighbours: [Seat], emptyTolerance: Int) -> Seat {
        switch self {
        case .empty:
            let occupiedNeighbours = neighbours.filter { $0 == .occupied }
            return occupiedNeighbours.isEmpty ? .occupied : .empty
        case .occupied:
            let occupiedNeighbours = neighbours.filter { $0 == .occupied }
            return occupiedNeighbours.count >= emptyTolerance ? .empty : .occupied
        case .floor:
            return .floor
        }
    }
}

struct SeatMap: Equatable {
    private let seats: [[Seat]]
    private let rows, cols: Int

    init(seats: [[Seat]]) {
        self.seats = seats
        self.rows = seats.count
        self.cols = seats[0].count
    }

    private func seat(row: Int, col: Int) -> Seat? {
        guard (0..<rows).contains(row), (0..<cols).contains(col) else {
            return nil
        }
        let seat = seats[row][col]
        return seat == .floor ? nil : seat
    }

    private func neighbours(row: Int, col: Int, depth: Int) -> [Seat] {
        var northWest, north, northEast, west, east, southWest, south, southEast: Seat?
        for d in (1...depth) {
            if northWest == nil { northWest = seat(row: row-d, col: col-d) }
            if north == nil { north = seat(row: row-d, col: col) }
            if northEast == nil { northEast = seat(row: row-d, col: col+d) }
            if west == nil { west = seat(row: row, col: col-d) }
            if east == nil { east = seat(row: row, col: col+d) }
            if southWest == nil { southWest = seat(row: row+d, col: col-d) }
            if south == nil { south = seat(row: row+d, col: col) }
            if southEast == nil { southEast = seat(row: row+d, col: col+d) }
        }
        return [northWest, north, northEast, west, east, southWest, south, southEast].compactMap { $0 }
    }

    func round(depth: Int, emptyTolerance: Int) -> SeatMap {
        var updatedSeats = self.seats
        for row in (0..<rows) {
            for col in (0..<cols) {
                let neighbour = neighbours(row: row, col: col, depth: depth)
                updatedSeats[row][col] = seats[row][col].newState(neighbours: neighbour, emptyTolerance: emptyTolerance)
            }
        }
        return SeatMap(seats: updatedSeats)
    }

    func occupiedSeatsCount() -> Int {
        var count = 0
        seats.forEach { (seatRow) in
            seatRow.forEach { (seat) in
                if seat == .occupied {
                    count += 1
                }
            }
        }
        return count
    }

    func debug() {
        for row in (0..<rows) {
            var rows = [Character]()
            for col in (0..<cols) {
                rows.append(seats[row][col].rawValue)
            }
            print(String(rows))
        }
        print("\n")
    }
}

class Puzzle11: Puzzle {

    let seats: [[Seat]]

    init() {
        seats = InputFileReader.readInput(id: "11").map { (str) -> [Seat] in
            let chars = Array(str)
            return chars.compactMap { Seat(rawValue: $0) }
        }
    }

    func part1() -> String {
        let occupied = occupiedSeats(depth: 1, emptyTolerance: 4)
        return "\(occupied)"
    }

    func part2() -> String {
        let occupied = occupiedSeats(depth: max(seats.count, seats[0].count), emptyTolerance: 5)
        return "\(occupied)"
    }

    private func occupiedSeats(depth: Int, emptyTolerance: Int) -> Int {
        var seatMap = SeatMap(seats: seats)
        var modified = true

        repeat {
            let updated = seatMap.round(depth: depth, emptyTolerance: emptyTolerance)
            if updated == seatMap {
                modified = false
            }
            seatMap = updated
        } while modified == true

        return seatMap.occupiedSeatsCount()
    }
}
