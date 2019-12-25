//
//  Bash.swift
//  matrix_symbolization
//
//  Created by Zz on 2019/12/24.
//  Copyright © 2019 ZZ. All rights reserved.
//

import Foundation

protocol CommandExecuting {
    func execute(commandName: String) -> (Int32, String?)
    func execute(commandName: String, arguments: [String]) -> (Int32, String?)
}

final class Bash: CommandExecuting {
    
    // MARK: - CommandExecuting
    
    func execute(commandName: String) -> (Int32, String?) {
        return execute(commandName: commandName, arguments: [])
    }
    
    func execute(commandName: String, arguments: [String]) -> (Int32, String?) {
        guard var bashCommand = execute(command: "/bin/bash" , arguments: ["-l", "-c", "which \(commandName)"]).1 else {
            return (-1, "\(commandName) not found")
        }
        
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return execute(command: bashCommand, arguments: arguments)
    }
    
    // MARK: Private
    
    private func execute(command: String, arguments: [String] = []) -> (Int32, String?) {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        process.waitUntilExit()
        pipe.fileHandleForReading.closeFile()

        return (process.terminationStatus, output)
    }
}


//let bash: CommandExecuting = Bash()
//if let lsOutput = bash.execute(commandName: "ls") { print(lsOutput) }
//if let lsWithArgumentsOutput = bash.execute(commandName: "ls", arguments: ["-la"]) { print(lsWithArgumentsOutput) }
