//
//  NotesListView.swift
//  MacOS_Note
//
//  Created by 賴柏澔 on 2024/8/15.
//

import SwiftUI

// 顯示筆記列表的主要視圖
struct NotesListView: View {
    // 觀察 NotesViewModel 物件，以便當資料變更時，自動更新視圖
    @ObservedObject var viewModel = NotesViewModel()
    
    var body: some View {
        // 建立一個導航視圖，讓使用者可以進入筆記的詳細頁面
        NavigationView {
            // 建立一個列表，顯示所有的筆記
            List {
                // 使用 ForEach 來迭代所有的筆記並顯示在列表中
                ForEach(viewModel.notes) { note in
                    // 導航連結到每個筆記的詳細頁面
                    NavigationLink(destination: NoteDetailView(note: note)) {
                        // 列表項目顯示筆記的標題
                        Text(note.title)
                    }
                }
                // 設定刪除功能，當使用者滑動項目時觸發刪除操作
                .onDelete(perform: viewModel.deleteNote)
            }
            // 設定導航標題
            .navigationTitle("Notes")
            // 工具列，包含新增筆記的按鈕
            .toolbar {
                // 工具列項目放置在右上角，作為主要操作
                ToolbarItem(placement: .primaryAction) {
                    // 新增筆記的按鈕
                    Button(action: viewModel.addNote) {
                        // 按鈕標籤，顯示加號圖示和 "Add Note" 字樣
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
        }
    }
}

