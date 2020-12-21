//
//  Puzzle16.swift
//  AOC2020
//
//  Created by jaydeep on 16/12/20.
//

import Foundation

struct Rule {
    let name: String
    let ranges: [ClosedRange<Int>]

    static func parse(from ruleStr: String) -> Rule? {
        let split = ruleStr.components(separatedBy: ": ")
        if split.count < 2 {
            return nil
        }
        let name = String(split[0])
        let ranges = split[1].components(separatedBy: " or ").map(Rule.parseRange)
        return Rule(name: name, ranges: ranges)
    }

    private static func parseRange(from rangeStr: String) -> ClosedRange<Int> {
        let split = rangeStr.split(separator: "-")
        let lower = Int(split[0])!
        let upper = Int(split[1])!
        return lower...upper
    }

    func matches(field: Int) -> Bool {
        ranges.first(where: { $0.contains(field) }) != nil
    }
}

class Puzzle16: Puzzle {
    var rules = [Rule]()
    var nearby = [[Int]]()
    var my = [Int]()

    init() {
        let input = InputFileReader.readInput(id: "16")
        input.forEach { (str) in
            if let rule = Rule.parse(from: str) {
                rules.append(rule)
            } else {
                nearby.append(str.components(separatedBy: ",").compactMap(Int.init))
            }
        }
        my = nearby.first!
        nearby = Array(nearby.dropFirst())
    }

    func part1() -> String {
        let names = nearby.map { (ticket) in
            ticket.map(allPossibleNames)
        }
        var tser = 0 // Ticket Scanning Error Rate
        names.indices.forEach { (i) in
            names[i].indices.forEach { (j) in
                if names[i][j].isEmpty {
                    tser += nearby[i][j]
                }
            }
        }
        return "\(tser)"
    }

    func part2() -> String {
        let names = nearby.map { (ticket) in
            ticket.map(allPossibleNames)
        }
        let allNamesSet = Set(rules.map(\.name))
        let myPossibleNames = my.indices.map { (idx) in
            return names.map { $0[idx] }.reduce(into: allNamesSet) { (acc, ns) in
                if !ns.isEmpty {
                    acc = acc.intersection(ns)
                }
            }
        }

        let myNames = simplifyNames(myPossibleNames)
        let answer = myNames.indices.reduce(into: 1) { (acc, index) in
            if myNames[index].starts(with: "departure") {
                acc = acc * my[index]
            }
        }
        return "\(answer)"
    }

    private func simplifyNames(_ names: [Set<String>]) -> [String] {
        var simplified = names
        var knownNames = simplified.filter { $0.count == 1 }
        while knownNames.count < simplified.count {
            var tmp = [Set<String>]() // tmp will be assigned to simplified at end of while loop
            for nameSet in simplified {
                var simplifiedSet = nameSet
                if nameSet.count > 1 {
                    knownNames.forEach { simplifiedSet = simplifiedSet.subtracting($0) }
                }
                tmp.append(simplifiedSet)
            }
            simplified = tmp
            knownNames = simplified.filter { $0.count == 1 }
        }
        return simplified.compactMap { $0.first }
    }

    private func allPossibleNames(field: Int) -> Set<String> {
        var names = Set<String>()
        rules.forEach { (rule) in
            if rule.matches(field: field) {
                names.insert(rule.name)
            }
        }
        return names
    }
}
