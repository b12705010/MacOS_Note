//
//  Item.swift
//  MacOS_Note
//
//  Created by 賴柏澔 on 2024/8/15.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
