//
//  Puzzle19.swift
//  AOC2020
//
//  Created by jaydeep on 17/12/20.
//

import Foundation
import Covfefe

class Puzzle19: Puzzle {
    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "19")
    }

    func part1() -> String {
        var rules = [String]()
        var messages = [String]()
        for str in input {
            if let _ = str.first!.wholeNumberValue {
                rules.append(toEbnf(str))
            } else {
                messages.append(str)
            }
        }
        return "\(matchingMessagesCount(rules: rules, messages: messages))"
    }

    func part2() -> String {
        var rules = [String]()
        var messages = [String]()
        for str in input {
            if str.starts(with: "8:") {
                rules.append(toEbnf("8: 42 | 42 8"))
            } else if str.starts(with: "11:") {
                rules.append(toEbnf("11: 42 31 | 42 11 31"))
            } else if let _ = str.first!.wholeNumberValue {
                rules.append(toEbnf(str))
            } else {
                messages.append(str)
            }
        }
        return "\(matchingMessagesCount(rules: rules, messages: messages))"
    }

    private func matchingMessagesCount(rules: [String], messages: [String]) -> Int {
        let grammarString = rules.joined(separator: "\n")
        let grammar = try! Grammar(ebnf: grammarString, start: "0")
        let parser = EarleyParser(grammar: grammar)
        return messages.filter(parser.recognizes).count
    }

    private func toEbnf(_ rule: String) -> String {
        let ruleChars = Array(rule)
        var ebnf = ""
        var parsingRhs = false
        for (idx, c) in ruleChars.enumerated() {
            if c == ":" {
                ebnf.append(" =")
                parsingRhs = true
            } else if parsingRhs, c == " ", ruleChars[idx+1] != "|",
                      ruleChars[idx-1] != "|", ruleChars[idx-1] != ":" {
                ebnf.append(", ")
            } else {
                ebnf.append(c)
            }
        }
        ebnf.append(";")
        return ebnf
    }
}
