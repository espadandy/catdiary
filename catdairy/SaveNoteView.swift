import SwiftUI

struct SaveNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var notesService: NotesService
    @EnvironmentObject private var storageService: StorageService
    @State private var name = ""
    @State private var description: String = ""
    @State private var image: Data? = nil

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $name)
                ZStack(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("Please enter your text here ...")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                            }
                            TextEditor(text: $description)
                                .padding(4)
                        }
//                        .frame(height: 150)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
            }

            Section("Picture") {
                PicturePicker(selectedData: $image)
            }
            Button("Improve English.") {
                Task {
                    let newText: String = await notesService.improve(text: description)
                    description = newText
                }
            }
            Button("Save Note") {
                let imageName = image != nil ? UUID().uuidString : nil
                let note = Note(
                    name: name,
                    description: description.isEmpty ? nil : description,
                    image: imageName
                )

                Task {
                    if let image, let imageName {
                        await storageService.upload(image, name: imageName)
                    }
                    await notesService.save(note)

                    dismiss()
                }
            }
        }
    }
}

#Preview {
    SaveNoteView()
}
