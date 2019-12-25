//
//  main.swift
//
//  Created by Zz on 2019/12/24.
//  Copyright © 2019 ZZ. All rights reserved.
//

import Foundation
import SPMUtility

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let parser = ArgumentParser(usage: "<options>", overview: "This is what this tool is for")
let dsyms: OptionArgument<String> = parser.add(option: "--dsyms", shortName: "-d", kind: String.self, usage: "dsYMs directory path")
let crash: OptionArgument<String> = parser.add(option: "--crash", shortName: "-c", kind: String.self, usage: "kscrash json file")

let parsedArguments = try parser.parse(arguments)


guard let dsymPath = parsedArguments.get(dsyms) else {
    print("no dsYMs path")
    exit(1)
}

guard let crashPath = parsedArguments.get(crash) else {
    print("no kscrash path")
    exit(1)
}

guard let crashData = NSData(contentsOfFile: crashPath) else {
    print("crash file not exist")
    exit(1)
}

let decoder = JSONDecoder()
guard let model = try? decoder.decode(KSCrash.self, from: crashData as Data) else {
    print("crash json format error")
    exit(1)
}

Symbolicate.start(dsymPath: dsymPath, crash: model)


// 在该项目目录下命令行执行:
// 1.swift build -c release (生成可执行文件)
// 2.cp .build/x86_64-apple-macosx/release/matrix_symbolization /user/local/bin (将可执行文件复制到执行路径中, 这样我们就可以在任何地方用这个工具了)
// 3.cp .source/matrix_symbolization/ks2apple.py /user/local/bin (因为依赖这个文件输出apple格式的crash，所以也需要拷贝)
