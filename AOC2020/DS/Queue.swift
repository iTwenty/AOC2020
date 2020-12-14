//
//  Queue.swift
//  AOC2020
//
//  Created by jaydeep on 14/12/20.
//

import Foundation

struct Queue<T> {
    fileprivate var array = [T]()

    var count: Int {
        return array.count
    }

    var isEmpty: Bool {
        return array.isEmpty
    }

    mutating func enqueue(_ element: T) {
        array.append(element)
    }

    mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }

    public var front: T? {
        return array.first
    }
}
