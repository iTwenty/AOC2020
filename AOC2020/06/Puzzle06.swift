//
//  Puzzle06.swift
//  AOC2020
//
//  Created by jaydeep on 06/12/20.
//

import Foundation

class Puzzle06: Puzzle {

    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "06", omitEmptySubsequences: false)
    }

    func part1() -> String {
        let sum = yesses(from: input).map { $0.count }.reduce(0, +)
        return "\(sum)"
    }

    func part2() -> String {
        let sum = yessesP2(from: input).map { $0.count }.reduce(0, +)
        return "\(sum)"
    }

    private func yesses(from input: [String]) -> [Set<Character>] {
        var yesses = [Set<Character>]()
        var currentYesses = Set<Character>()
        for i in input {
            if i == "" {
                yesses.append(currentYesses)
                currentYesses = []
            } else {
                for c in i {
                    currentYesses.insert(c)
                }
            }
        }
        return yesses
    }

    private func yessesP2(from input: [String]) -> [Set<Character>] {
        var yesses = [Set<Character>]()
        var personYesses = [Set<Character>]()
        for i in input {
            if i == "" {
                let commonYesses = personYesses.dropFirst().reduce(personYesses.first!) { (acc, personYes) in
                    acc.intersection(personYes)
                }
                yesses.append(commonYesses)
                personYesses = []
            } else {
                personYesses.append(Set(i))
            }
        }
        return yesses
    }
}
