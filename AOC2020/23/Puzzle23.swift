//
//  Puzzle23.swift
//  AOC2020
//
//  Created by jaydeep on 23/12/20.
//

import Foundation

fileprivate enum Input {
    case challenge, test
    var input: [Int] {
        switch self {
        case .challenge: return [Character]("792845136").compactMap { $0.wholeNumberValue }
        case .test: return [Character]("389125467").compactMap { $0.wholeNumberValue }
        }
    }
}

class Puzzle23: Puzzle {
    let input = Input.challenge.input

    func part1() -> String {
        var cups = input
        var index = 0
        for _ in (0..<100) {
            (cups, index) = playCrabCups(cups, index)
        }
        return "\(cups.map(String.init).joined())"
    }

    // Should give out correct answer if left running for couple of hours.
    // TODO : Use circular linked list for representing cups and dict for keeping track of active cup
    func part2() -> String {
        var cups = input
        var index = 0
        for i in ((cups.max()!+1)..<1000000) {
            cups.append(i)
        }
        for _ in (0..<10000000) {
            (cups, index) = playCrabCups(cups, index)
        }
        let oneIndex = cups.firstIndex(of: 1)!
        return "\(cups[oneIndex+1] * cups[oneIndex+2])"
    }

    private func playCrabCups(_ cups: [Int], _ index: Int) -> ([Int], Int) {
        let minCup = cups.min()!
        let maxCup = cups.max()!
        var newCups = cups
        let (mi1, mi2, mi3) = ((index+1) % cups.count, (index+2) % cups.count, (index+3) % cups.count)
        let (m1, m2, m3) = (cups[mi1], cups[mi2], cups[mi3])
        newCups.removeAll(at: [mi1, mi2, mi3])
        var destination = cups[index] - 1
        while (m1 == destination || m2 == destination || m3 == destination || newCups.firstIndex(of: destination) == nil)  {
            destination -= 1
            if destination < minCup {
                destination = maxCup
            }
        }
        let destinationIndex = newCups.firstIndex(of: destination)!
        newCups.insert(m1, at: destinationIndex + 1)
        newCups.insert(m2, at: destinationIndex + 2)
        newCups.insert(m3, at: destinationIndex + 3)
        let currentCup = cups[index]
        let newIndex = (newCups.firstIndex(of: currentCup)! + 1) % newCups.count
        return (newCups, newIndex)
    }
}
