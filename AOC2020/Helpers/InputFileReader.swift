//
//  InputFileReader.swift
//  AOC2020
//
//  Created by jaydeep on 01/12/20.
//

import Foundation

class InputFileReader {
    static func readInput(id: String, separator: Character = "\n", omitEmptySubsequences: Bool = true) -> [String] {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleUrl = URL(fileURLWithPath: "InputFiles.bundle", relativeTo: currentDirectoryURL)
        let bundle = Bundle(url: bundleUrl)
        let inputFileUrl = bundle!.url(forResource: "Input\(id)", withExtension: nil)!
        let contents = try! String(contentsOf: inputFileUrl, encoding: .utf8)
        let input: [String] = contents.split(separator: separator,
                                             maxSplits: Int.max,
                                             omittingEmptySubsequences: omitEmptySubsequences).map(String.init)
        return input
    }
}
