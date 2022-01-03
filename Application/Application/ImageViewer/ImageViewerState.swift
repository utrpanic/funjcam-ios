import Entity

struct ImageViewerState {
  var searchImage: SearchImage
}

enum ImageViewerEvent {
  case loading(Bool)
  case error(Error)
}
