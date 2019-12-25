//
//  KSCrash.swift
//  matrix_symbolization
//
//  Created by Zz on 2019/12/24.
//

import Foundation

class System: NSObject, Codable {
    var binary_cpu_type: Int?
    var binary_cpu_subtype: Int?
    var CFBundleExecutablePath: String?

    var cpuArch: String?
    var processName: String?
    var osVersion: String?
    var systemVersion: String?

    var shortAppVersion: String?
    var appVersion: String?
    var cpuType: Int?
    var appStartTime: String?
    var appId: String?
    var jailbroken: Bool?
    var machine: String?

    var applicationStats: ApplicationStats?
    var memory: Memory?

    enum CodingKeys: String, CodingKey {
        case binary_cpu_type = "binary_cpu_type"
        case binary_cpu_subtype = "binary_cpu_subtype"
        case CFBundleExecutablePath = "CFBundleExecutablePath"

        case cpuArch = "cpu_arch"
        case processName = "process_name"
        case osVersion = "os_version"
        case systemVersion = "system_version"
        case shortAppVersion = "CFBundleShortVersionString"
        case appVersion = "CFBundleVersion"
        case cpuType = "cpu_type"
        case appStartTime = "app_start_time"
        case appId = "CFBundleIdentifier"
        case jailbroken = "jailbroken"
        case machine = "machine"
        case applicationStats = "application_stats"
        case memory = "memory"
    }
}

class ApplicationStats: NSObject, Codable {
    var background_time_since_last_crash: Int?
    var active_time_since_launch: Float?
    var app_launch_time: TimeInterval?
    var sessions_since_last_crash: Int?
    var launches_since_last_crash: Int?
    var active_time_since_last_crash: Float?
    var sessions_since_launch: Int?
    var application_active: Bool?
    var application_in_foreground: Bool?
    var background_time_since_launch: Int?
}

class Memory: NSObject, Codable {
    var free: Int?
    var size: Int?
    var usable: Int?
}

class Crash: NSObject, Codable {
    var threads: [Thread]?
    var error: Error?

    enum CodingKeys: String, CodingKey {
        case threads = "threads"
        case error = "error"
    }
}

class Error: NSObject, Codable {
    var mach: Mach?
    var user_reported: UserReported?
    var reason: String?
    var signal: signal?
    var type: String?
    var address: Int?
}

class Mach: NSObject, Codable {
    var subcode: Int?
    var exception: Int?
    var code: Int?
}

class UserReported: NSObject, Codable {
    var name: String?
    var dump_type: Int?
    var language: String?
}

class signal: NSObject, Codable {
    var signal: Int?
    var code: Int?
}

class Thread: NSObject, Codable {
    var backtrace: BackTrace?
    var current_thread: Bool?
    var crashed: Bool?
    var name: String?
    var index: Int?
    
    enum CodingKeys: String, CodingKey {
        case backtrace = "backtrace"
        case current_thread = "current_thread"
        case crashed = "crashed"
        case name = "name"
        case index = "index"
    }
}

class BackTrace: NSObject, Codable {
    var contents: [BackTraceContent]?
   
    enum CodingKeys: String, CodingKey {
        case contents = "contents"
    }
}

class BackTraceContent: NSObject, Codable {
    var repeatCount: Int?
    var symbolName: String?
    var symbolAddr: Int?
    var instructionAddr: Int?
    var objectName: String?
    var objectAddr: Int?

    enum CodingKeys: String, CodingKey {
        case repeatCount = "repeat_count"
        case symbolName = "symbol_name"
        case symbolAddr = "symbol_addr"
        case instructionAddr = "instruction_addr"
        case objectName = "object_name"
        case objectAddr = "object_addr"
    }
}

class BinaryImage: NSObject, Codable {
    var major_version: Int?
    var revision_version: Int?
    var cpu_subtype: Int?
    var uuid: String?
    var image_vmaddr: Int?
    var image_addr: Int?
    var image_size: Int?
    var minor_version: Int?
    var name: String?
    var cpu_type: Int?
}

class User: NSObject, Codable {
    var email: String?
    var username: String?
    var uin: Int?
    var udid: String?
}

class Report: NSObject, Codable {
    var process_name: String?
    var id: String?
    var timestamp: TimeInterval?
    var type: String?
    var version: String?
}

class KSCrash: NSObject, Codable {
    var system: System?
    var crash: Crash?
    var binaryImages: [BinaryImage]?
    var user: User?
    var report: Report?

    enum CodingKeys: String, CodingKey {
        case system = "system"
        case crash = "crash"
        case binaryImages = "binary_images"
        case user = "user"
        case report = "report"
    }
}
