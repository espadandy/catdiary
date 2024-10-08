import Authenticator

import SwiftUI

struct NotesView: View {
    @State var notes: [Note] = []
    @EnvironmentObject private var notesService: NotesService
    @EnvironmentObject var state: SignedInState
    @EnvironmentObject private var storageService: StorageService
    @State private var isSavingNote = false

    var body: some View {
        NavigationStack {
            List {
                if notesService.notes.isEmpty {
                    Text("No notes")
                }
                ForEach(notesService.notes, id: \.id) { note in
                    NoteView(note: note)
                }
                .onDelete { indices in
                    for index in indices {
                        let note = notesService.notes[index]
                        Task {
                            await notesService.delete(note)
                            if let image = note.image {
                                await storageService.remove(withName: image)
                            }
                        }
                    }
                }
            }
            .refreshable {
                await notesService.fetchNotes()
            }
            .toolbar {
                Button("Sign Out") {
                    Task {
                        await state.signOut()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("⨁ New Note") {
                        isSavingNote = true
                    }
                    .bold()
                }
            }
            .sheet(isPresented: $isSavingNote) {
                SaveNoteView()
            }
            .navigationTitle("Notes")
        }
        .task {
            await notesService.fetchNotes()
        }


    }
}

#Preview {
    NotesView()
        .environmentObject(
            NotesService([
                Note(
                    name:"This is title",
                    description: "I am writing a note."
                )
            ])
        )
}
