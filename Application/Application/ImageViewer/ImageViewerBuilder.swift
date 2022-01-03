import Entity

public protocol ImageViewerBuildable {
  func build(searchImage: SearchImage) -> ViewControllable
}

public final class ImageViewerBuilder: ImageViewerBuildable {
  
  private let dependency: ImageViewerDependency
  private weak var listener: ImageViewerListener?
  
  public init(dependency: ImageViewerDependency, listener: ImageViewerListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func build(searchImage: SearchImage) -> ViewControllable {
    let controller = ImageViewerController(
      searchImage: searchImage,
      dependency: self.dependency,
      listener: self.listener
    )
    return ImageViewerViewController(controller: controller)
  }
}
