//
//  DPDump.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/27.
//

import Foundation

func DPDumpText<T>(_ value: T) -> String {
    let mirror = Mirror(reflecting: value)
    return """
           Type: \(type(of: value))
               \(mirror.children.map { "\($0.label ?? ""): \($0.value)" }.joined(separator: "\n    "))
           """
}
