//
//  Sequence+SortedKeyPath.swift
//  Sequence+SortedKeyPath
//
//  Created by Nayan Jansari on 08/08/2021.
//

import Foundation

extension Sequence {
    func sorted<Value>(by keyPath: KeyPath<Element, Value>, using areInIncreasingOrder: (Value, Value) throws -> (Bool)) rethrows -> [Element] {
        try sorted { try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: keyPath, using: <)
    }
}
