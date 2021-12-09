import Entity

public protocol ImageViewerDependency {
  func shareBuilder() -> ShareBuildable
  func alertBuilder() -> AlertBuildable
}

public protocol ImageViewerListener: AnyObject {
  
}

public protocol ImageViewerBuildable {
  func build(searchedImage: SearchedImage) -> ViewControllable
}

public final class ImageViewerBuilder: ImageViewerBuildable {
  
  private let dependency: ImageViewerDependency
  private weak var listener: ImageViewerListener?
  
  public init(dependency: ImageViewerDependency, listener: ImageViewerListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func build(searchedImage: SearchedImage) -> ViewControllable {
    let controller = ImageViewerController(
      searchedImage: searchedImage,
      dependency: self.dependency,
      listener: self.listener
    )
    return ImageViewerViewController(controller: controller)
  }
}
