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
        let sum = yesses(from: input) { $0.union($1) }.map { $0.count }.reduce(0, +)
        return "\(sum)"
    }

    func part2() -> String {
        let sum = yesses(from: input) { $0.intersection($1) }.map { $0.count }.reduce(0, +)
        return "\(sum)"
    }

    private func yesses(from input: [String], op: (Set<Character>, Set<Character>) -> Set<Character>) -> [Set<Character>] {
        var yesses = [Set<Character>]()
        var personYesses = [Set<Character>]()
        for i in input {
            if i == "" {
                let commonYesses = personYesses.dropFirst().reduce(personYesses.first!, op)
                yesses.append(commonYesses)
                personYesses = []
            } else {
                personYesses.append(Set(i))
            }
        }
        return yesses
    }
}
