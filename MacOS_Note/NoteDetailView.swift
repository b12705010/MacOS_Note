//
//  NoteDetailView.swift
//  MacOS_Note
//
//  Created by 賴柏澔 on 2024/8/15.
//

import SwiftUI
import AppKit

struct NoteDetailView: View {
    @State var note: Note

    var body: some View {
        VStack(alignment: .leading) {
            // 工具列，包含格式化和插入表格按鈕
            HStack {
                Button(action: insertTable) {
                    Image(systemName: "tablecells")
                    Text("Insert Table")
                }
                
                Button(action: applyBold) {
                    Image(systemName: "bold")
                    Text("Bold")
                }
                
                Button(action: applyItalic) {
                    Image(systemName: "italic")
                    Text("Italic")
                }
            }
            .padding()
            .background(Color.clear)

            Divider()

            RichTextEditor(text: $note.content)  // 使用自訂的富文本編輯器
                .frame(maxHeight: .infinity)
        }
        .padding()
        .navigationTitle(note.title)
    }

    // 插入表格的操作邏輯（示例，具體根據需求實現）
    func insertTable() {
        // 插入表格邏輯可以根據您的需求設計
        print("Insert Table pressed")
    }

    func applyBold() {
        if let mutableText = note.content.mutableCopy() as? NSMutableAttributedString {
            // 假設選中的是整個文本。您可以根據需求調整選擇範圍
            let selectedRange = NSRange(location: 0, length: mutableText.length)

            mutableText.enumerateAttribute(.font, in: selectedRange, options: []) { value, range, _ in
                if let currentFont = value as? NSFont {
                    var fontDescriptor = currentFont.fontDescriptor

                    // 切換粗體樣式
                    if fontDescriptor.symbolicTraits.contains(.bold) {
                        fontDescriptor = fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits.subtracting(.bold))
                    } else {
                        fontDescriptor = fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits.union(.bold))
                    }

                    if let updatedFont = NSFont(descriptor: fontDescriptor, size: currentFont.pointSize) {
                        mutableText.addAttribute(.font, value: updatedFont, range: range)
                    }
                }
            }

            // 只在確定更改後更新 note.content，並且保持其他內容不變
            note.content = mutableText
        }
    }

    func applyItalic() {
        if let mutableText = note.content.mutableCopy() as? NSMutableAttributedString {
            // 假設選中的是整個文本。您可以根據需求調整選擇範圍
            let selectedRange = NSRange(location: 0, length: mutableText.length)

            mutableText.enumerateAttribute(.font, in: selectedRange, options: []) { value, range, _ in
                if let currentFont = value as? NSFont {
                    var fontDescriptor = currentFont.fontDescriptor

                    // 切換斜體樣式
                    if fontDescriptor.symbolicTraits.contains(.italic) {
                        fontDescriptor = fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits.subtracting(.italic))
                    } else {
                        fontDescriptor = fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits.union(.italic))
                    }

                    if let updatedFont = NSFont(descriptor: fontDescriptor, size: currentFont.pointSize) {
                        mutableText.addAttribute(.font, value: updatedFont, range: range)
                    }
                }
            }

            // 只在確定更改後更新 note.content，並且保持其他內容不變
            note.content = mutableText
        }
    }



}
