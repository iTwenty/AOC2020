//
//  Puzzle22.swift
//  AOC2020
//
//  Created by jaydeep on 22/12/20.
//

import Foundation

fileprivate enum Winner: Int { case player1, player2 }
fileprivate typealias GameResult = (winner: Winner, winnerDeck: [Int])

class Puzzle22: Puzzle {
    var deck1 = [Int](), deck2 = [Int]() // 0 means top of deck, last means bottom. d1 is crab, d2 is human

    init() {
        let input = InputFileReader.readInput(id: "22")
        var parsingD2 = false
        for str in input {
            if let card = Int(str) {
                if parsingD2 {
                    deck2.append(card)
                } else {
                    deck1.append(card)
                }
            } else if str == "Player 2:" {
                parsingD2 = true
            }
        }
    }

    func part1() -> String {
        let answer = score(deck: playCombat(deck1, deck2).winnerDeck)
        return "\(answer)"
    }

    func part2() -> String {
        let answer = score(deck: playRecursiveCombat(deck1, deck2).winnerDeck)
        return "\(answer)"
    }

    // Returns the winner's deck
    private func playCombat(_ deck1: [Int], _ deck2: [Int]) -> GameResult {
        var (d1, d2) = (deck1, deck2) // d1, d2 decks are modified as game progresses
        while !(d1.isEmpty || d2.isEmpty) {
            let (d1Card, d2Card) = (d1.remove(at: 0), d2.remove(at: 0))
            if d1Card > d2Card {
                d1 += [d1Card, d2Card]
            } else {
                d2 += [d2Card, d1Card]
            }
        }
        return d1.isEmpty ? (.player2, d2) : (.player1, d1)
    }

    // Returns the winning player and his/her/it's deck
    private func playRecursiveCombat(_ deck1: [Int], _ deck2: [Int]) -> GameResult {
        var (d1, d2) = (deck1, deck2) // d1, d2 decks are modified as game progresses
        var seenDeck1s = Set<[Int]>()
        var seenDeck2s = Set<[Int]>()
        while !(d1.isEmpty || d2.isEmpty) {
            if seenDeck1s.contains(d1) && seenDeck2s.contains(d2) {
                return (.player1, d1)
            }
            seenDeck1s.insert(d1)
            seenDeck2s.insert(d2)
            let (d1Card, d2Card) = (d1.remove(at: 0), d2.remove(at: 0))
            if d1Card <= d1.count && d2Card <= d2.count {
                switch playRecursiveCombat(Array(d1[..<d1Card]), Array(d2[..<d2Card])).winner {
                case .player1:
                    d1 += [d1Card, d2Card]
                case .player2:
                    d2 += [d2Card, d1Card]
                }
            } else if d1Card > d2Card {
                d1 += [d1Card, d2Card]
            } else {
                d2 += [d2Card, d1Card]
            }
        }
        return d1.isEmpty ? (.player2, d2) : (.player1, d1)
    }

    private func score(deck: [Int]) -> Int {
        return deck.enumerated().reduce(into: 0) { (acc, enumeration) in
            let (idx, card) = enumeration
            let multiplier = deck.count - idx
            acc += (multiplier * card)
        }
    }
}
