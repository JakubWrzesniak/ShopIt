//
//  Exstends.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 14/12/2021.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension UIImage {
    public convenience init?(fromDocuments: String) {
        self.init(contentsOfFile: URL.urlInDocumentsDirectory(with: fromDocuments).path)
    }
}

extension URL {
    static var documentsDirectory: URL {
        let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return directory
    }

    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}
