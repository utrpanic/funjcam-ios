import SwiftUI
import Entity

struct BookmarkState {
  var bookmarks: [BookmarkImage]
}

struct BookmarkView: View {
  
  @State var state: BookmarkState
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct BookmarkView_Previews: PreviewProvider {
  static var previews: some View {
    let state = BookmarkState(bookmarks: [])
    BookmarkView(state: state)
  }
}
