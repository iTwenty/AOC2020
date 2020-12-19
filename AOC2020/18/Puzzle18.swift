//
//  Puzzle18.swift
//  AOC2020
//
//  Created by jaydeep on 17/12/20.
//

import Foundation

class Puzzle18: Puzzle {
    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "18")
    }

    func part1() -> String {
        let precedences: [Character: Int] = ["+": 1, "*": 1, "(": 0]
        let sum = input.map { evaluate(expression: $0, precedences: precedences) }.reduce(0, +)
        return "\(sum)"
    }

    func part2() -> String {
        let precedences: [Character: Int] = ["+": 2, "*": 1, "(": 0]
        let sum = input.map { evaluate(expression: $0, precedences: precedences) }.reduce(0, +)
        return "\(sum)"
    }

    private func evaluate(expression: String, precedences: [Character: Int]) -> Int {
        let infix = Array(expression).filter { $0 != " " }
        let postfix = toPostfix(infix, precedences: precedences)
        var stack = Stack<Int>()
        for c in postfix {
            if let num = c.wholeNumberValue {
                stack.push(num)
            } else if c == "+" {
                stack.push(stack.pop()! + stack.pop()!)
            } else {
                stack.push(stack.pop()! * stack.pop()!)
            }
        }
        assert(stack.count == 1)
        return stack.pop()!
    }

    private func toPostfix(_ infix: [Character], precedences: [Character: Int]) -> [Character] {
        var postfix = [Character]()
        var opStack = Stack<Character>()
        for c in infix {
            if c.wholeNumberValue != nil {
                postfix.append(c)
            } else if c == "(" {
                opStack.push(c)
            } else if c == ")" {
                while let popped = opStack.pop(), popped != "(" {
                    postfix.append(popped)
                }
            } else {
                while let top = opStack.top, precedences[top]! >= precedences[c]! {
                    postfix.append(opStack.pop()!)
                }
                opStack.push(c)
            }
        }
        while let popped = opStack.pop() {
            postfix.append(popped)
        }
        return postfix
    }
}
