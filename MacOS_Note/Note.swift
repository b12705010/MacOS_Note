//
//  Note.swift
//  MacOS_Note
//
//  Created by 賴柏澔 on 2024/8/15.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: NSAttributedString
    
    // 自訂的編碼邏輯，將 NSAttributedString 編碼為 Data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        
        // 將 NSAttributedString 轉換為 Data 進行編碼
        let data = try content.data(from: NSRange(location: 0, length: content.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
        try container.encode(data, forKey: .content)
    }
    
    // 自訂的解碼邏輯，將 Data 解碼為 NSAttributedString
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        // 將 Data 轉換回 NSAttributedString
        let data = try container.decode(Data.self, forKey: .content)
        self.content = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
    }
    
    // 初始化器
    init(title: String, content: NSAttributedString) {
        self.id = UUID()
        self.title = title
        self.content = content
    }
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = NSAttributedString(string: content)
    }
    
    // 定義編碼和解碼的鍵值
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
    }
}
