import SwiftUI
import Entity

protocol BookmarkViewDelegate: AnyObject {
  
}

struct BookmarkView: View {
  
  @State var state: BookmarkState
  weak var delegate: BookmarkViewDelegate?
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct BookmarkView_Previews: PreviewProvider {
  static var previews: some View {
    let state = BookmarkState()
    BookmarkView(state: state)
  }
}
