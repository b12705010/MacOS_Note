//
//  RichTextEditor.swift
//  MacOS_Note
//
//  Created by 賴楠天 on 2024/8/16.
//

import Foundation
import SwiftUI
import AppKit

struct RichTextEditor: NSViewRepresentable {
    @Binding var text: NSAttributedString

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()

        // 基本配置
        textView.isRichText = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.usesFontPanel = true
        textView.textStorage?.setAttributedString(text)

        // 根據系統外觀模式設置文本顏色
        updateTextColor(textView)

        // 設置 NSScrollView 並包裹 NSTextView
        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false  // 保持透明背景

        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            // 只在文本變更時更新，避免覆蓋格式化
            if textView.attributedString() != text {
                textView.textStorage?.setAttributedString(text)
            }
            updateTextColor(textView)  // 根據外觀模式更新文字顏色
        }
    }


    // 更新文本顏色根據系統外觀模式
    func updateTextColor(_ textView: NSTextView) {
        if let appearance = textView.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) {
            let textColor: NSColor = (appearance == .darkAqua) ? .white : .black
            let range = NSRange(location: 0, length: textView.textStorage?.length ?? 0)
            textView.textStorage?.addAttribute(.foregroundColor, value: textColor, range: range)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        // 檢測文本變更
        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                parent.text = textView.attributedString()
                
                // 取得第一行的範圍
                let firstLineRange = (textView.string as NSString).lineRange(for: NSRange(location: 0, length: 0))
                
                // 獲取第一行的文字內容
                let firstLineText = (textView.string as NSString).substring(with: firstLineRange)
                
                // 更新文檔標題
                NotificationCenter.default.post(name: Notification.Name("UpdateTitle"), object: firstLineText)
            }
        }
    }


}
