import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            NavigationStack {
                Home()
                    .navigationTitle("To-Do")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

