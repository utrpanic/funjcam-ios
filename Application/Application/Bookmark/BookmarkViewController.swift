import Combine
import UIKit
import SwiftUI

protocol BookmarkControllable {
  var observableState: ObservableState<BookmarkState> { get }
  var observableEvent: ObservableEvent<BookmarkEvent> { get }
  func activate(with viewController: BookmarkViewControllable)
}

final class BookmarkViewController: UIHostingController<BookmarkView>, BookmarkViewControllable, BookmarkViewDelegate {
  
  private let controller: BookmarkControllable
  private var cancellables: Set<AnyCancellable>
  
  init(controller: BookmarkControllable) {
    self.controller = controller
    self.cancellables = Set<AnyCancellable>()
    let initialState = controller.observableState.currentValue
    let rootView = BookmarkView(state: initialState)
    super.init(rootView: rootView)
    self.controller.activate(with: self)
    self.rootView.delegate = self
  }
  
  @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.observeState()
    self.observeEvent()
  }
  
  private func observeState() {
    self.controller.observableState
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.rootView.state = state
      }
      .store(in: &(self.cancellables))
  }
  
  private func observeEvent() {
    self.controller.observableEvent
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      }
      .store(in: &(self.cancellables))
  }
}
