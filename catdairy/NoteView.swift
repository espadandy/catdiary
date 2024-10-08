import SwiftUI

struct NoteView: View {
    @State var note: Note

    var body: some View {
        HStack(alignment: .center, spacing: 5.0) {
            VStack(alignment: .leading, spacing: 5.0) {
                if let name = note.name {
                    Text(name)
                        .bold()
                }
                if let description = note.description {
                    Text(description)
                }

                if let image = note.image {
                    Spacer()
                    RemoteImage(name: image)
//                        .frame(width: 90, height: 90)
                }
            }
        }
    }
}
