import SwiftUI

import Amplify
import Authenticator

struct ContentView: View {
    var body: some View {
        Authenticator { state in
            VStack {
                NotesView()
                    .environmentObject(NotesService())
                    .environmentObject(StorageService())
            }
        }
    }
}

#Preview {
    ContentView()
}
