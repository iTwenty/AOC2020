//
//  ConsoleProgram.swift
//  AOC2020
//
//  Created by jaydeep on 08/12/20.
//

import Foundation

enum Instruction {
    case acc(Int)
    case jmp(Int)
    case nop(Int)
}

enum TerminationReason {
    case infiniteLoop
    case endOfInstructions
}

class ConsoleProgram {
    private let program: [Instruction]
    private(set) var accValue = 0
    private var counter = 0
    private var alreadyExecuted: Set<Int> = []

    init(program: [Instruction]) {
        self.program = program
    }

    func execute() -> TerminationReason {
        accValue = 0
        counter = 0
        alreadyExecuted = []
        while counter < program.count {
            if alreadyExecuted.contains(counter) {
                return .infiniteLoop
            }
            alreadyExecuted.insert(counter)
            let currentInstruction = program[counter]
            switch currentInstruction {
            case .acc(let value):
                accValue += value
                counter = counter + 1
            case .jmp(let value):
                counter += value
            case .nop:
                counter = counter + 1
            }
        }
        return .endOfInstructions
    }
}
