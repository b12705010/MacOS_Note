//
//  NotesViewModel.swift
//  MacOS_Note
//
//  Created by 賴柏澔 on 2024/8/15.
//

import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] {
        didSet {
            saveNotes()
        }
    }
    
    // 使用 lazy 來延遲初始化 notes 屬性
    init() {
        self.notes = []  // 先給一個空的陣列
        self.notes = loadNotes()  // 然後再載入實際的筆記
    }
    
    func addNote() {
        let newNote = Note(title: "New Note", content: "New note content.")
        notes.append(newNote)
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    private func saveNotes() {
        let encoder = PropertyListEncoder()
        if let encodedNotes = try? encoder.encode(notes) {
            UserDefaults.standard.set(encodedNotes, forKey: "notes")
        }
    }
    
    private func loadNotes() -> [Note] {
        if let savedNotesData = UserDefaults.standard.data(forKey: "notes") {
            let decoder = PropertyListDecoder()
            if let decodedNotes = try? decoder.decode([Note].self, from: savedNotesData) {
                return decodedNotes
            }
        }
        return []
    }
}

