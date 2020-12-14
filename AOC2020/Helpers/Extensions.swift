//
//  Extensions.swift
//  AOC2020
//
//  Created by jaydeep on 14/12/20.
//

import Foundation

extension String {
    func pad(toSize: Int, withChar char: Character = "0") -> String {
        var padded = self
        for _ in 0..<(toSize - count) {
            padded.insert(char, at: startIndex)
        }
        return padded
    }
}
