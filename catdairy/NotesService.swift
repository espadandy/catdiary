import Amplify
import SwiftUI

@MainActor
class NotesService: ObservableObject {
    @Published var notes: [Note]

    init(_ notes: [Note] = []) {
        self.notes = notes
    }

    func fetchNotes() async {
        do {
            let result = try await Amplify.API.query(request: .list(Note.self))
            switch result {
            case .success(let notesList):
                print("Fetched \(notesList.count) notes")
                notes = notesList.elements
            case .failure(let error):
                print("Fetch Notes failed with error: \(error)")
            }
        } catch {
            print("Fetch Notes failed with error: \(error)")
        }
    }

    func improve(text: String) async -> String  {
        let doc = """
        query ImproveEnglishQuery($description: String!) {
                improveEnglish(description: $description)
            }
        """
        let result = try! await Amplify.API.query(request: GraphQLRequest<String>(
            document: doc,
            variables: [
                "description": text
            ],
            responseType: String.self
        ))
        switch result {
        case .success(let response):
            struct Response: Codable {
                let improveEnglish: String
            }
            if let jsonData = response.data(using: .utf8) {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: jsonData)
                    print("Improve English content: \(response.improveEnglish)")
                    return response.improveEnglish
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    print(error)
                }
            }
        case .failure(let error):
            print(error)
        }
        return text
    }

    func save(_ note: Note) async {
        do {
            let result = try await Amplify.API.mutate(request: .create(note))
            switch result {
            case .success(let note):
                print("Save note completed")
                notes.append(note)
            case .failure(let error):
                print("Save Note failed with error: \(error)")
            }
        } catch {
            print("Save Note failed with error: \(error)")
        }
    }

    func delete(_ note: Note) async {
        do {
            let result = try await Amplify.API.mutate(request: .delete(note))
            switch result {
            case .success(let note):
                print("Delete note completed")
                notes.removeAll(where: { $0.id == note.id })
            case .failure(let error):
                print("Delete Note failed with error: \(error)")
            }
        } catch {
            print("Delete Note failed with error: \(error)")
        }
    }
}
