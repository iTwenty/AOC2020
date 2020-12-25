//
//  Puzzle25.swift
//  AOC2020
//
//  Created by Jaydeep Joshi on 25/12/20.
//

import Foundation

fileprivate enum Input {
    case challenge, test
    
    var cardpk: Int {
        switch self {
        case .challenge: return 5099500
        case .test: return 5764801
        }
    }
    
    var doorpk: Int {
        switch self {
        case .challenge: return 7648211
        case .test: return 17807724
        }
    }
}

class Puzzle25: Puzzle {
    fileprivate let input = Input.challenge
    fileprivate let (cardpk, doorpk): (Int, Int)
    
    init() {
        cardpk = input.cardpk
        doorpk = input.doorpk
    }

    func part1() -> String {
        let cardls = loopSize(pk: cardpk)
        let doorls = loopSize(pk: doorpk)
        print(cardls, doorls)
        let ek = encryptionKey(pk: cardpk, loopSize: doorls)
        return "\(ek)"
    }
    
    func part2() -> String {
        return "Merry Christmas y'all!"
    }
    
    private func transform(_ num: Int, sn: Int) -> Int {
        return (num * sn) % 20201227
    }
    
    private func loopSize(pk: Int) -> Int {
        var loopSize = 1
        var num = 7
        while num != pk {
            num = transform(num, sn: 7)
            loopSize += 1
        }
        return loopSize
    }
    
    private func encryptionKey(pk: Int, loopSize: Int) -> Int {
        var key = 1
        for _ in (0..<loopSize) {
            key = transform(key, sn: pk)
        }
        return key
    }
}
