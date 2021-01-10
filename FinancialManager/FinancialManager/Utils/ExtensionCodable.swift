//
//  ExtensionCodable.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 09/01/21.
//

import Foundation
import UIKit

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
