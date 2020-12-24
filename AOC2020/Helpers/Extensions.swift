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

extension RangeReplaceableCollection where Index: Hashable {
    public mutating func removeAll<C>(at collection: C) where C: Collection, C.Element == Index {
        let indices = Set(collection)
        precondition(indices.count == collection.count && indices.allSatisfy(self.indices.contains))
        indices.lazy.sorted().enumerated().forEach { (offset, index) in
            let shiftedIndex = self.index(index, offsetBy: -offset)
            remove(at: shiftedIndex)
        }
    }
}
