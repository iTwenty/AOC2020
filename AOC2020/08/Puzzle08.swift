//
//  Puzzle08.swift
//  AOC2020
//
//  Created by jaydeep on 08/12/20.
//

import Foundation

class Puzzle08: Puzzle {

    let instructions: [Instruction]

    init() {
        instructions = InputFileReader.readInput(id: "08").compactMap { (str) -> Instruction? in
            let instructionStr = str.components(separatedBy: " ")
            let (opStr, value) = (instructionStr[0], Int(instructionStr[1])!)
            switch opStr {
            case "acc": return .acc(value)
            case "jmp": return .jmp(value)
            case "nop": return .nop(value)
            default: return nil
            }
        }
    }

    func part1() -> String {
        let console = ConsoleProgram(program: instructions)
        let reason = console.execute()
        if reason == .infiniteLoop {
            return "\(console.accValue)"
        }
        return "No infinite loop :("
    }

    func part2() -> String {
        let permutations = self.permutations()
        for instructions in permutations {
            let program = ConsoleProgram(program: instructions)
            let reason = program.execute()
            if reason == .endOfInstructions {
                return "\(program.accValue)"
            }
        }
        return "No program reached end of instructions :("
    }

    private func permutations() -> [[Instruction]] {
        var permutations = [[Instruction]]()
        for (index, instruction) in instructions.enumerated() {
            var instructionsCopy = instructions
            if case .jmp(let value) = instruction {
                instructionsCopy[index] = .nop(value)
                permutations.append(instructionsCopy)
            }
            if case .nop(let value) = instruction {
                instructionsCopy[index] = .jmp(value)
                permutations.append(instructionsCopy)
            }
        }
        return permutations
    }
}
