//
//  Puzzle01.swift
//  AOC2020
//
//  Created by jaydeep on 01/12/20.
//

import Foundation

struct Puzzle01: Puzzle {

    private let numbers: [Int]

    init() {
        numbers = InputFileReader.readInput(id: "01").compactMap {
            Int($0)
        }
    }

    func part1() -> String {
        for number in numbers {
            let antiNumber = 2020 - number
            if numbers.contains(antiNumber) {
                return "\(number * antiNumber)"
            }
        }
        return "No such number pair found!!!"
    }

    func part2() -> String {
        for number in numbers {
            let remainingSum = 2020 - number
            for innerNumber in numbers {
                let antiNumber = remainingSum - innerNumber
                if (numbers.contains(antiNumber)) {
                    print("\(number), \(innerNumber), \(antiNumber)")
                    return "\(number * innerNumber * antiNumber)"
                }
            }
        }
        return "No such number triplet found!!!"
    }
}
