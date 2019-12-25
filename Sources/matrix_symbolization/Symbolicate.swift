//
//  Symbolicate.swift
//  matrix_symbolization
//
//  Created by Zz on 2019/12/24.
//

import Foundation

class Symbolicate {
    class func start(dsymPath: String, crash: KSCrash) {
        guard let threads = crash.crash?.threads else {
            print("threads is empty")
            exit(1)
        }
        
        /*
         We go through each thread and create a dictionary of image name and all occurences of instruction symbols.
         images = {
         "libdispatch.dylib": [instruction_addr, instruction_addr, ...],
         "UIKit": [...],
         ...
         }
         */
        
        var instructions: [String: Set<Int>] = [:]
        var objectAddrs: [String: Int] = [:]
        for thread in threads {
            guard let contents = thread.backtrace?.contents else {
                continue
            }
            
            for content in contents {
                guard let objectName = content.objectName,
                    let objectAddr = content.objectAddr,
                    let instructionAddr = content.instructionAddr else {
                        continue
                }
                                
                var instrucInfo = instructions[objectName]
                if instrucInfo == nil {
                    instrucInfo = []
                }
                
                instrucInfo?.insert(instructionAddr)
                instructions[objectName] = instrucInfo
                
                objectAddrs[objectName] = objectAddr
            }
        }
        
        symbolicateImages(dsymPath: dsymPath, instructions: instructions, objectAddrInfo: objectAddrs, crash: crash)
    }
    
    class func symbolicateImages(dsymPath: String, instructions: [String: Set<Int>], objectAddrInfo: [String: Int], crash: KSCrash) {
        guard let subPaths = try? FileManager.default.contentsOfDirectory(atPath: dsymPath) else {
            print("dsymPath is empty")
            exit(1)
        }
                
        var symblicateInfo: [String: [Int: String]] = [:]
        
        for (imageName, instructions) in instructions {
            guard let objectAddr = objectAddrInfo[imageName] else {
                continue
            }
            
            if imageName.hasSuffix("dylib") {
                // TODO: 系统动态库
            } else {
                var dsymSubpath = "\(imageName).framework.dSYM"
                if imageName == crash.system?.processName {
                    dsymSubpath = "\(imageName).app.dSYM"
                }
                
                // 第三方framework
                if subPaths.contains(dsymSubpath) {
                    let dsymPath = "\(dsymPath)/\(dsymSubpath)/Contents/Resources/DWARF/\(imageName)"
                    
                    let bash: CommandExecuting = Bash()
                    
                    var arguments: [String] = []
                    arguments.append("-o")
                    arguments.append(dsymPath)
                    arguments.append("-arch")
                    arguments.append(crash.system?.cpuArch ?? "arm64")
                    arguments.append("-l")
                    arguments.append(Conversion.decTohex(number: objectAddr))
                    
                    let hexInstructions = instructions.map { Conversion.decTohex(number: $0) }
                    arguments.append(contentsOf: hexInstructions)

                    
                    let result = bash.execute(commandName: "atos", arguments: arguments)
                    if result.0 == 0 {
                        if var output = result.1 {
                            output = output.trimmingCharacters(in: .whitespacesAndNewlines)
                            let outputs = output.components(separatedBy: "\n")
                            
                            var instrSymbols: [Int: String] = [:]
                            
                            var index = 0
                            for instruc in instructions {
                                if index >= outputs.count {
                                    break
                                }
                                
                                instrSymbols[instruc] = outputs[index]
                                index += 1
                            }
                            
                            symblicateInfo[imageName] = instrSymbols
                        }
                    } else {
                        print("atos failed with \(result.0)")
                    }
                        
                } else {
                    // TODO: 系统framework
                }
            }
            
            
            

        }
        
        symbolicateCrash(crash, symblicateInfo: symblicateInfo)
    }

    class func symbolicateCrash(_ crash: KSCrash, symblicateInfo: [String: [Int: String]]) {
        if let threads = crash.crash?.threads {
            for thread in threads {
                if let contents = thread.backtrace?.contents {
                    for content in contents {
                        guard let objectName = content.objectName,
                            let instructionAddr = content.instructionAddr else {
                                continue
                        }
                        
                        if let symbolInfo = symblicateInfo[objectName],
                            let symbolName = symbolInfo[instructionAddr] {
                            content.symbolName = symbolName
                        }
                    }
                    
                    thread.backtrace?.contents = contents
                }
            }
            
           toAppleCrashReport(crash: crash)
            
        }
        
    }
    
    class func toAppleCrashReport(crash: KSCrash) {
        if let data = try? JSONEncoder().encode(crash) {
            if let _ = String(data: data, encoding: .utf8) {
                
                var arguments: [String] = []
                
                let jsonPath = NSTemporaryDirectory().appending("temp.json")
                try? data.write(to: URL(fileURLWithPath: jsonPath))
                
                let scriptPath = Bundle.main.path(forResource: "ks2apple", ofType: "py")!
                arguments.append(scriptPath)
                arguments.append("-i")
                arguments.append(jsonPath)
                arguments.append("-o")
                arguments.append("./temp.crash")
                
    
                let bash: CommandExecuting = Bash()
                let result = bash.execute(commandName: "python", arguments: arguments)
                if result.0 == 0 {
                    print("to apple crash report succeed")
                }
            }
        }
    }
}



//atos -o ~/Library/Developer/Xcode/iOS\ DeviceSupport/13.3\ \(17C54\)/Symbols/usr/lib/system/libsystem_platform.dylib -arch arm64 -l 1963BC000 1963C25BC
//atos -o /Users/mac/Desktop/matrix_symbolization/dSYMs -arch arm64 -l 10404C000 10550BA40 104BDFDF4 105B81B88 105883D30
