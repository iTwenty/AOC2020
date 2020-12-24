//
//  Puzzle15.swift
//  AOC2020
//
//  Created by jaydeep on 14/12/20.
//

import Foundation

fileprivate enum Input {
    case challenge, example, test1

    var data: [Int] {
        switch self {
        case .challenge: return [0,14,6,20,1,4]
        case .example: return [0,3,6]
        case .test1: return [3,1,2]
        }
    }
}

class Puzzle15: Puzzle {

    let input: [Int]

    init() {
        input = Input.challenge.data
    }

    func part1() -> String {
        return "\(playGame(turns: 2020))"
    }

    func part2() -> String {
        return "\(playGame(turns: 30000000))"
    }

    var numberTurnDict = [Int: Int]()
    private func playGame(turns: Int) -> Int {
        numberTurnDict.removeAll()
        var currentNumbers = input
        currentNumbers.enumerated().forEach { numberTurnDict[$1] = $0 }
        while currentNumbers.count < turns {
            currentNumbers.append(age(currentNumbers))
        }
        return currentNumbers.last!
    }

    private func age(_ currentNumbers: [Int]) -> Int {
        let lastNum = currentNumbers.last!
        let turn = currentNumbers.count - 1
        let age = turn - (numberTurnDict[lastNum] ?? turn)
        numberTurnDict[lastNum] = turn
        return age
    }
}
