//
//  Puzzle02.swift
//  AOC2020
//
//  Created by jaydeep on 02/12/20.
//

import Foundation

class Puzzle02: Puzzle {
    let pattern = #"([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)"#
    var input: [(Int, Int, Character, String)] = []

    init() {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        InputFileReader.readInput(id: "02").forEach { (str) in
            let range = NSRange(str.startIndex..<str.endIndex, in: str)
            regex.enumerateMatches(in: str, options: [], range: range) { (match, flags, top) in
                guard let match = match, match.numberOfRanges == 5,
                      let loRange = Range(match.range(at: 1), in: str),
                      let hiRange = Range(match.range(at: 2), in: str),
                      let charRange = Range(match.range(at: 3), in: str),
                      let passRange = Range(match.range(at: 4), in: str) else { return }
                let fst = Int(str[loRange])!
                let snd = Int(str[hiRange])!
                let char = Character(String(str[charRange]))
                let pass = String(str[passRange])
                input.append((fst, snd, char, pass))
            }
        }
    }

    func part1() -> String {
        let count = input.filter { validUsingFirstPolicy(lo: $0.0, hi: $0.1, char: $0.2, pass: $0.3) }.count
        return "\(count)"
    }

    func part2() -> String {
        let count = input.filter { validUsingSecondPolicy(fst: $0.0, snd: $0.1, char: $0.2, pass: $0.3) }.count
        return "\(count)"
    }

    private func validUsingFirstPolicy(lo: Int, hi: Int, char: Character, pass: String) -> Bool {
        (lo...hi).contains(pass.filter { $0 == char }.count)
    }

    private func validUsingSecondPolicy(fst: Int, snd: Int, char: Character, pass: String) -> Bool {
        let fstChar = pass[pass.index(pass.startIndex, offsetBy: fst - 1)]
        let sndChar = pass[pass.index(pass.startIndex, offsetBy: snd - 1)]
        return (fstChar == char && sndChar != char) || (fstChar != char && sndChar == char)
    }
}
