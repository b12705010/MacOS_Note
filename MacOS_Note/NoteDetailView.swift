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
                Button(action: applyTitle) {
                    Text("Title")
                }
                
                Button(action: applyHeading) {
                    Text("Heading")
                }
                
                Button(action: applySubtitle) {
                    Text("Subtitle")
                }

                Button(action: applyBody) {
                    Text("Body")
                }

                Button(action: applyBold) {
                    Image(systemName: "bold")
                    Text("Bold")
                }
                
                Button(action: applyItalic) {
                    Image(systemName: "italic")
                    Text("Italic")
                }
                
                Button(action: saveNote) {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                }
            }
            .padding()

            Divider()

            RichTextEditor(text: $note.content)
                .frame(maxHeight: .infinity)
        }
        .padding()
        .navigationTitle(note.title)
    }

    // Title 樣式
    func applyTitle() {
        applyFontStyle(size: 28, weight: .bold)
    }

    // Heading 樣式
    func applyHeading() {
        applyFontStyle(size: 22, weight: .semibold)
    }

    // Subtitle 樣式
    func applySubtitle() {
        applyFontStyle(size: 18, weight: .medium)
    }

    // Body 樣式
    func applyBody() {
        applyFontStyle(size: 14, weight: .regular)
    }

    // 應用字體樣式
    func applyFontStyle(size: CGFloat, weight: NSFont.Weight) {
        if let textView = firstResponderTextView() {
            let selectedRange = textView.selectedRange()
            if selectedRange.length > 0, let textStorage = textView.textStorage {
                let attributedString = textStorage.attributedSubstring(from: selectedRange).mutableCopy() as! NSMutableAttributedString

                attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, _ in
                    if let font = value as? NSFont {
                        let newFontDescriptor = font.fontDescriptor
                        if let newFont = NSFont(descriptor: newFontDescriptor, size: size) {
                            let fontWithWeight = NSFont.systemFont(ofSize: size, weight: weight)
                            attributedString.addAttribute(.font, value: fontWithWeight, range: range)
                        }
                    }
                }

                textStorage.replaceCharacters(in: selectedRange, with: attributedString)
            }
        }
    }


    func applyBold() {
        applyFontTrait(.bold)
    }

    func applyItalic() {
        applyFontTrait(.italic)
    }

    // 應用字體屬性（如粗體、斜體）
    func applyFontTrait(_ trait: NSFontDescriptor.SymbolicTraits) {
        if let textView = firstResponderTextView() {
            let selectedRange = textView.selectedRange()
            if selectedRange.length > 0, let textStorage = textView.textStorage {
                let attributedString = textStorage.attributedSubstring(from: selectedRange).mutableCopy() as! NSMutableAttributedString

                attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, _ in
                    if let font = value as? NSFont {
                        var traits = font.fontDescriptor.symbolicTraits
                        traits.insert(trait)
                        let newFontDescriptor = font.fontDescriptor.withSymbolicTraits(traits)
                        if let newFont = NSFont(descriptor: newFontDescriptor, size: font.pointSize) {
                            attributedString.addAttribute(.font, value: newFont, range: range)
                        }
                    }
                }

                textStorage.replaceCharacters(in: selectedRange, with: attributedString)
            }
        }
    }

    func saveNote() {
        if let textView = firstResponderTextView() {
            let savedAttributedString = textView.attributedString()
            
            // 將格式化好的文本保存到 Note 中
            if let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) {
                viewModel.notes[index].content = savedAttributedString
                viewModel.saveNotes()
            }
            print("Note saved!")
        }
    }

    func firstResponderTextView() -> NSTextView? {
        return NSApp.keyWindow?.firstResponder as? NSTextView
    }
}
