import Entity

struct RecentState {
  var images: [RecentImage]
}

enum RecentEvent {
  case errorRequestRecentImage(Error)
}
