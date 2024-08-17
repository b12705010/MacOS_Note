//
//  NotesViewModel.swift
//  MacOS_Note
//
//  Created by 賴柏澔 on 2024/8/15.
//

import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []  // 預設為空的陣列

    init() {
        // 使用延遲加載來避免初始化時使用 self
        DispatchQueue.main.async {
            self.notes = self.loadNotes()
        }
    }
    
    func initAddNote() {
        let newNote = Note(title: "New Note", content: "New note content.")
        notes.append(newNote)
    }

    
    func addNote(title: String, content: NSAttributedString) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
    }

    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }

    func saveNotes() {
        let encoder = PropertyListEncoder()
        if let encodedNotes = try? encoder.encode(notes) {
            UserDefaults.standard.set(encodedNotes, forKey: "notes")
        }
    }

    func loadNotes() -> [Note] {
        if let savedNotesData = UserDefaults.standard.data(forKey: "notes") {
            let decoder = PropertyListDecoder()
            if let decodedNotes = try? decoder.decode([Note].self, from: savedNotesData) {
                return decodedNotes
            }
        }
        return []
    }
}
