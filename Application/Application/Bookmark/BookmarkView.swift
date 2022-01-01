import SwiftUI
import Entity

protocol BookmarkViewDelegate: AnyObject {
  
}

struct BookmarkView: View {
  
  var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
  
  @State var state: BookmarkState
  weak var delegate: BookmarkViewDelegate?
  
  var body: some View {
    if state.images.isEmpty {
      Text("No Bookmarks")
    } else {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(state.images) {
            Text($0.name)
          }
        }
      }
    }
  }
}

struct BookmarkView_Previews: PreviewProvider {
  static var previews: some View {
    let state = BookmarkState(images: [])
    BookmarkView(state: state)
  }
}
