//
//  Edge.swift
//  AOC2020
//
//  Created by jaydeep on 07/12/20.
//

import Foundation

class Edge {

    let srcIndex: Int
    let dstIndex: Int
    let weight: Int

    init(srcIndex: Int, dstIndex: Int, weight: Int) {
        self.srcIndex = srcIndex
        self.dstIndex = dstIndex
        self.weight = weight
    }
}
