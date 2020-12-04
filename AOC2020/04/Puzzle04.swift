//
//  Puzzle04.swift
//  AOC2020
//
//  Created by jaydeep on 04/12/20.
//

import Foundation

class Puzzle04: Puzzle {
    
    let input: [String]
    let requiredKeySet: Set<String> = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    
    init() {
        input = InputFileReader.readInput(id: "04", omitEmptySubsequences: false)
    }
    
    func part1() -> String {
        let count = readPassports(input).filter(areRequiredKeysPresent).count
        return "\(count)"
    }
    
    func part2() -> String {
        let count = readPassports(input).filter(isValidPassport).count
        return "\(count)"
    }

    private func areRequiredKeysPresent(_ passport: [String: String]) -> Bool {
        requiredKeySet.isSubset(of: Set(passport.keys))
    }

    private func isValidPassport(_ passport: [String: String]) -> Bool {
        guard areRequiredKeysPresent(passport) else {
            return false
        }
        return isValidByr(passport["byr"]) &&
        isValidIyr(passport["iyr"]) &&
        isValidEyr(passport["eyr"]) &&
        isValidHcl(passport["hcl"]) &&
        isValidHgt(passport["hgt"]) &&
        isValidEcl(passport["ecl"]) &&
        isValidPid(passport["pid"])
    }

    private func isValidByr(_ byr: String?) -> Bool {
        if let byr = byr, let intByr = Int(byr), (1920...2002).contains(intByr) { return true }
        return false
    }

    private func isValidIyr(_ iyr: String?) -> Bool {
        if let iyr = iyr, let intIyr = Int(iyr), (2010...2020).contains(intIyr) { return true }
        return false
    }

    private func isValidEyr(_ eyr: String?) -> Bool {
        if let eyr = eyr, let intEyr = Int(eyr), (2020...2030).contains(intEyr) { return true }
        return false
    }

    private func isValidHgt(_ hgt: String?) -> Bool {
        if let hgt = hgt, let intHgt = Int(hgt.dropLast(2)) {
            let hgtUnit = hgt.suffix(2)
            if hgtUnit == "cm" {
                return (150...193).contains(intHgt)
            } else if hgtUnit == "in" {
                return (59...76).contains(intHgt)
            }
        }
        return false
    }

    private func isValidHcl(_ hcl: String?) -> Bool {
        if let hcl = hcl, hcl.count == 7, let fst = hcl.first, fst == "#" {
            let color = hcl.dropFirst()
            let charSet: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7",
                                           "8", "9", "a", "b", "c", "d", "e", "f"]
            return color.allSatisfy { charSet.contains($0) }
        }
        return false
    }

    private func isValidEcl(_ ecl: String?) -> Bool {
        if let ecl = ecl, ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(ecl) {
            return true
        }
        return false
    }

    private func isValidPid(_ pid: String?) -> Bool {
        if let pid = pid, pid.count == 9, let _ = Int(pid) {
            return true
        }
        return false
    }

    private func readPassports(_ input: [String]) -> [[String: String]] {
        var passports: [[String: String]] = []
        var currentPassport: [String: String] = [:]
        for i in input {
            if i == "" {
                passports.append(currentPassport)
                currentPassport = [:]
            } else {
                let kvPairLine = i.split(separator: " ")
                let kvPairsArray = kvPairLine.map { $0.split(separator: ":") }
                for kvPairArray in kvPairsArray {
                    currentPassport[String(kvPairArray[0])] = String(kvPairArray[1])
                }
            }
        }
        return passports
    }
}
