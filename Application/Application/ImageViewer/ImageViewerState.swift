import Entity

struct ImageViewerState {
  var searchedImage: SearchedImage
}

enum ImageViewerError: Error {
  
}

enum ImageViewerViewState {
  case loading(Bool)
  case stateArrived(ImageViewerState)
  case errorArrived(ImageViewerError)
}
