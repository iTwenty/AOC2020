//
//  Puzzle12Complex.swift
//  AOC2020
//
//  Created by jaydeep on 12/12/20.
//

// Puzzle 12 using complex numbers from Swift Numerics package
import Foundation
import ComplexModule

fileprivate class Ship {
    private static var directions = [
        "N": Complex(imaginary: 1),
        "S": Complex(imaginary: -1),
        "E": Complex(1),
        "W": Complex(-1)
    ]

    private var direction = Complex(1, 0)
    private var position = Complex(0, 0)
    private var waypoint = Complex(10, 1)

    var manhattan: Int {
        Int(abs(position.real) + abs(position.imaginary))
    }

    func navigate(instruction: String) {
        var value = Double(instruction.dropFirst())!
        let op = String(instruction.first!)
        switch op {
        case "F":
            position += (direction * Complex<Double>(value))
        case "R":
            while value > 0 {
                direction = direction * Complex(imaginary: -1)
                value -= 90
            }
        case "L":
            while value > 0 {
                direction = direction * Complex(imaginary: 1)
                value -= 90
            }
        default:
            if let dir = Ship.directions[op] {
                position += (Complex(value) * dir)
            } else {
                fatalError()
            }
        }
    }

    func navigatep2(instruction: String) {
        var value = Double(instruction.dropFirst())!
        let op = String(instruction.first!)
        switch op {
        case "F":
            position += (Complex(value) * waypoint)
        case "R":
            while value > 0 {
                waypoint = waypoint * Complex(imaginary: -1)
                value -= 90
            }
        case "L":
            while value > 0 {
                waypoint = waypoint * Complex(imaginary: 1)
                value -= 90
            }
        default:
            if let dir = Ship.directions[op] {
                waypoint += (Complex(value) * dir)
            } else {
                fatalError()
            }
        }
    }
}

class Puzzle12Complex: Puzzle {

    let input: [String]

    init() {
        input = InputFileReader.readInput(id: "12")
    }

    func part1() -> String {
        let ship = Ship()
        input.forEach(ship.navigate)
        return "\(ship.manhattan)"
    }

    func part2() -> String {
        let ship = Ship()
        input.forEach(ship.navigatep2)
        return "\(ship.manhattan)"
    }
}
