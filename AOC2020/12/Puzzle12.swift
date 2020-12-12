//
//  Puzzle12.swift
//  AOC2020
//
//  Created by jaydeep on 12/12/20.
//

import Foundation

enum Rotation {
    case R(Int), L(Int)

    static func from(_ char: String, value: Int) -> Rotation? {
        switch char {
        case "R": return Rotation.R(value)
        case "L": return Rotation.L(value)
        default: return nil
        }
    }
}

enum Movement {
    case N(Int), E(Int), W(Int), S(Int), F(Int)

    static func from(_ char: String, value: Int) -> Movement? {
        switch char {
        case "N": return Movement.N(value)
        case "E": return Movement.E(value)
        case "W": return Movement.W(value)
        case "S": return Movement.S(value)
        case "F": return Movement.F(value)
        default: return nil
        }
    }
}

enum Direction: String {
    case N, E, S, W

    var right: Direction {
        switch self {
        case .N: return Direction.E
        case .E: return Direction.S
        case .S: return Direction.W
        case .W: return Direction.N
        }
    }

    var left: Direction {
        switch self {
        case .N: return Direction.W
        case .E: return Direction.N
        case .S: return Direction.E
        case .W: return Direction.S
        }
    }

    func newDirection(rotation: Rotation) -> Direction {
        var direction = self
        switch rotation {
        case .L(var angle):
            while angle > 0 {
                direction = direction.left
                angle -= 90
            }
        case .R(var angle):
            while angle > 0 {
                direction = direction.right
                angle -= 90
            }
        }
        return direction
    }
}

struct Position {
    static let origin = Position(x: 0, y: 0)
    var x, y: Int

    mutating func move(movement: Movement, direction: Direction) {
        switch movement {
        case .N(let value): y += value
        case .E(let value): x += value
        case .W(let value): x -= value
        case .S(let value): y -= value
        case .F(let value): move(movement: Movement.from(direction.rawValue, value: value)!, direction: direction)
        }
    }

    mutating func rotate(rotation: Rotation) {
        switch rotation {
        case .L(var angle):
            while angle > 0 {
                swap(&x, &y)
                x = -x
                angle -= 90
            }
        case .R(var angle):
            while angle > 0 {
                swap(&x, &y)
                y = -y
                angle -= 90
            }
        }
    }

    static func +(lhs: Position, rhs: Position) -> Position {
        Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func -(lhs: Position, rhs: Position) -> Position {
        Position(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func *(multiplier: Int, position: Position) -> Position {
        Position(x: multiplier * position.x, y: multiplier * position.y)
    }
}

fileprivate class Ship {
    private var direction: Direction
    private var position: Position // always relative to origin
    private var waypointPosition: Position // always relative to origin

    init() {
        direction = .E
        position = .origin
        waypointPosition = Position(x: 10, y: 1)
    }

    func navigate(instruction: String, guesswork: Bool) {
        let action = String(instruction.first!)
        let value = Int(instruction.dropFirst())!
        if let movement = Movement.from(action, value: value) {
            guesswork ? move(movement) : moveProperly(movement)
        } else if let rotation = Rotation.from(action, value: value) {
            guesswork ? rotate(rotation) : rotateProperly(rotation)
        }
    }

    var manhattan: Int {
        abs(position.x) + abs(position.y)
    }

    private func move(_ movement: Movement) {
        position.move(movement: movement, direction: direction)
    }

    private func moveProperly(_ movement: Movement) {
        if case .F(let value) = movement {
            let relativePos = waypointPosition - position
            position = position + (value * relativePos)
            waypointPosition = position + relativePos
        } else {
            waypointPosition.move(movement: movement, direction: direction)
        }
    }

    private func rotate(_ rotation: Rotation) {
        direction = direction.newDirection(rotation: rotation)
    }

    private func rotateProperly(_ rotation: Rotation) {
        var relativePos = waypointPosition - position
        relativePos.rotate(rotation: rotation)
        waypointPosition = position + relativePos
    }
}

class Puzzle12: Puzzle {
    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "12")
    }

    func part1() -> String {
        let ship = Ship()
        input.forEach { ship.navigate(instruction: $0, guesswork: true) }
        return "\(ship.manhattan)"
    }

    func part2() -> String {
        let ship = Ship()
        input.forEach { ship.navigate(instruction: $0, guesswork: false) }
        return "\(ship.manhattan)"
    }
}
