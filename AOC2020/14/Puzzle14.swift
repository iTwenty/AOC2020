//
//  Puzzle14.swift
//  AOC2020
//
//  Created by jaydeep on 13/12/20.
//

import Foundation

class Puzzle14: Puzzle {

    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "14")
    }

    func part1() -> String {
        var currentMask = Array(repeating: "x", count: 36).joined()
        var mmap = [Int64: Int64]()
        for instruction in input {
            if instruction.starts(with: "mask") {
                currentMask = instruction.components(separatedBy: " = ")[1]
            } else if instruction.starts(with: "mem") {
                let address = Int64(instruction.split(separator: "[")[1].split(separator: "]")[0])!
                let value = Int64(instruction.components(separatedBy: " = ")[1])!
                let mvalue = maskedValue(value, mask: currentMask)
                mmap[address] = mvalue
            }
        }
        let sum = mmap.values.reduce(0, +)
        return "\(sum)"
    }

    func part2() -> String {
        var currentMask = Array(repeating: "x", count: 36).joined()
        var mmap = [Int64: Int64]()
        for instruction in input {
            if instruction.starts(with: "mask") {
                currentMask = instruction.components(separatedBy: " = ")[1]
            } else if instruction.starts(with: "mem") {
                let address = Int64(instruction.split(separator: "[")[1].split(separator: "]")[0])!
                let value = Int64(instruction.components(separatedBy: " = ")[1])!
                let maskedAddress = maskedAddresses(address, mask: currentMask)
                maskedAddress.forEach { mmap[$0] = value }
            }
        }
        let sum = mmap.values.reduce(0, +)
        return "\(sum)"
    }

    private func maskedValue(_ value: Int64, mask: String) -> Int64 {
        let binaryValue = String(value, radix: 2)
        let paddedValue = binaryValue.pad(toSize: mask.count)
        let maskedValueChars = zip(paddedValue, mask).map { (valueChar, maskChar) in
            maskChar == "X" ? valueChar : maskChar
        }
        let maskedValueStr = String(maskedValueChars)
        return Int64(maskedValueStr, radix: 2)!
    }

    private func maskedAddresses(_ address: Int64, mask: String) -> [Int64] {
        let binaryAddress = String(address, radix: 2)
        let paddedAddress = binaryAddress.pad(toSize: mask.count)
        let maskedAddressChars = zip(paddedAddress, mask).map { (addressChar, maskChar) in
            maskChar == "0" ? addressChar : maskChar
        }
        var all = [[Character]]()
        var addressQueue = Queue<[Character]>()
        addressQueue.enqueue(maskedAddressChars)
        while let mac = addressQueue.dequeue() {
            var isFloating = false
            for (idx, char) in mac.enumerated() {
                if char == "X" {
                    isFloating = true
                    var zero = mac
                    var one = mac
                    zero[idx] = "0"
                    one[idx] = "1"
                    addressQueue.enqueue(zero)
                    addressQueue.enqueue(one)
                    break
                }
            }
            if !isFloating {
                all.append(mac)
            }
        }

        return all.map { Int64(String($0), radix: 2)! }
    }
}
