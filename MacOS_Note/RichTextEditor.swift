//
//  RichTextEditor.swift
//  MacOS_Note
//
//  Created by 賴楠天 on 2024/8/16.
//

import Foundation
import SwiftUI
import AppKit

// 在 macOS 中使用 NSTextView 來實現富文本編輯器
struct RichTextEditor: NSViewRepresentable {
    @Binding var text: NSAttributedString

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()

        textView.isRichText = true  // 支援富文本
        textView.isEditable = true  // 確保可編輯
        textView.isSelectable = true  // 確保可選擇文字
        textView.allowsUndo = true  // 允許撤銷操作
        textView.usesFontPanel = true  // 支援字體面板
        
        // 設置背景透明
        textView.drawsBackground = false  // 移除背景色
        
        // 設置成為第一響應者，讓它能夠接受鍵盤輸入
        DispatchQueue.main.async {
            textView.window?.makeFirstResponder(textView)
        }

        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false  // 滾動視圖背景透明

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            textView.textStorage?.setAttributedString(text)  // 更新 NSTextView 的內容
            textView.isEditable = true  // 再次確保它是可編輯的
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

        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                parent.text = textView.attributedString()
            }
        }
    }
}
