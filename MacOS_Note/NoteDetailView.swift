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
            .onAppear {
                // 註冊通知以監聽標題變更
                NotificationCenter.default.addObserver(forName: Notification.Name("UpdateTitle"), object: nil, queue: .main) { notification in
                    if let newTitle = notification.object as? String {
                        note.title = newTitle
                    }
                }
            }
            .onDisappear {
                // 移除通知監聽器
                NotificationCenter.default.removeObserver(self, name: Notification.Name("UpdateTitle"), object: nil)
            }
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
                        var fontDescriptor = font.fontDescriptor
                        
                        // 保留現有的符號屬性 (如粗體和斜體)
                        let existingTraits = fontDescriptor.symbolicTraits
                        
                        // 使用新的大小和權重創建字體
                        var newFontDescriptor = NSFontDescriptor(name: font.fontName, size: size)
                        newFontDescriptor = newFontDescriptor.withSymbolicTraits(existingTraits)
                        
                        let newFont = NSFont(descriptor: newFontDescriptor, size: size)
                        attributedString.addAttribute(.font, value: newFont!, range: range)
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
    // 應用或移除字體屬性（如粗體、斜體）
    func applyFontTrait(_ trait: NSFontDescriptor.SymbolicTraits) {
        if let textView = firstResponderTextView() {
            let selectedRange = textView.selectedRange()
            if selectedRange.length > 0, let textStorage = textView.textStorage {
                let attributedString = textStorage.attributedSubstring(from: selectedRange).mutableCopy() as! NSMutableAttributedString

                attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, _ in
                    if let font = value as? NSFont {
                        var traits = font.fontDescriptor.symbolicTraits

                        // 切換字體屬性，如果已存在則移除，否則添加
                        if traits.contains(trait) {
                            traits.remove(trait)
                        } else {
                            traits.insert(trait)
                        }

                        let newFontDescriptor = font.fontDescriptor.withSymbolicTraits(traits)
                        let newFont = NSFont(descriptor: newFontDescriptor, size: font.pointSize)

                        attributedString.addAttribute(.font, value: newFont, range: range)
                    }
                }

                textStorage.replaceCharacters(in: selectedRange, with: attributedString)
            }
        }
    }



    func saveNote() {
        if let textView = firstResponderTextView() {
            let savedAttributedString = textView.attributedString()

            // 獲取第一行的範圍
            let firstLineRange = (textView.string as NSString).lineRange(for: NSRange(location: 0, length: 0))
            // 獲取第一行的文字內容並更新標題
            let firstLineText = (textView.string as NSString).substring(with: firstLineRange)
            note.title = firstLineText.trimmingCharacters(in: .whitespacesAndNewlines) // 去除首尾空白

            // 將格式化好的文本保存到 Note 中
            if let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) {
                viewModel.notes[index].content = savedAttributedString
                viewModel.notes[index].title = note.title // 確保標題同步更新
                viewModel.saveNotes()
            }
            print("Note saved with title: \(note.title)")
        }
    }


    func firstResponderTextView() -> NSTextView? {
        return NSApp.keyWindow?.firstResponder as? NSTextView
    }
}
