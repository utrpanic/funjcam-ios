import Entity

struct ImageViewerState {
  var searchedImage: SearchedImage
}

enum ImageViewerEvent {
  case loading(Bool)
  case error(Error)
}
