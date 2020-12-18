//
//  Stack.swift
//  AOC2020
//
//  Created by jaydeep on 18/12/20.
//

import Foundation

struct Stack<T> {
    private var array = [T]()

    var isEmpty: Bool {
        return array.isEmpty
    }

    var count: Int {
        return array.count
    }

    mutating func push(_ element: T) {
        array.append(element)
    }

    mutating func pop() -> T? {
        return array.popLast()
    }

    var top: T? {
        return array.last
    }
}
