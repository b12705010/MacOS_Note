//
//  NoteDetailView.swift
//  MacOS_Note
//
//  Created by 賴柏澔 on 2024/8/15.
//

import SwiftUI
import AppKit

struct NoteDetailView: View {
    @Binding var note: Note
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        VStack(alignment: .leading) {
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
                
                // 新增 Save 按鈕
                Button(action: saveNote) {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                }
            }
            .padding()
            .background(Color.clear)

            Divider()

            RichTextEditor(text: $note.content)
                .frame(maxHeight: .infinity)
        }
        .padding()
        .navigationTitle(note.title)
    }

    func insertTable() {
        print("Insert Table pressed")
    }

    func applyBold() {
        // 印出原始的 note.content
        print("Before applying bold: \(note.content.string)")

        if let mutableText = note.content.mutableCopy() as? NSMutableAttributedString {
            let selectedRange = NSRange(location: 0, length: mutableText.length)
            mutableText.enumerateAttribute(.font, in: selectedRange, options: []) { value, range, _ in
                if let currentFont = value as? NSFont {
                    var fontDescriptor = currentFont.fontDescriptor
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

            // 更新 note.content 並印出變更後的內容
            note.content = mutableText
            print("After applying bold: \(note.content.string)")
        }
    }


    func applyItalic() {
        // 印出原始的 note.content
        print("Before applying italic: \(note.content.string)")
        
        if let mutableText = note.content.mutableCopy() as? NSMutableAttributedString {
            let selectedRange = NSRange(location: 0, length: mutableText.length)
            mutableText.enumerateAttribute(.font, in: selectedRange, options: []) { value, range, _ in
                if let currentFont = value as? NSFont {
                    var fontDescriptor = currentFont.fontDescriptor
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
            note.content = mutableText
            print("After applying italic: \(note.content.string)")
        }
    }

    // 儲存筆記的內容
    func saveNote() {
        // 印出原始的 note.content
        print("Before applying saved: \(note.content.string)")
        
        if let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) {
            viewModel.notes[index].content = note.content  // 更新 ViewModel 中對應的筆記
            viewModel.saveNotes()  // 儲存到 UserDefaults
        }
        print("After applying saved: \(note.content.string)")
        print("Note saved!")
    }
}
