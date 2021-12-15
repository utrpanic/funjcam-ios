import Combine

public class ObservableState<T>: Publisher {
  
  public typealias Output = T
  public typealias Failure = Never
  
  private let subject: CurrentValueSubject<T, Never>
  public var currentValue: T { self.subject.value }
  
  public init(subject: CurrentValueSubject<T, Never>) {
    self.subject = subject
  }
  
  public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, T == S.Input {
    self.subject.receive(subscriber: subscriber)
  }
}

public class ObservableEvent<T>: Publisher {
  
  public typealias Output = T
  public typealias Failure = Never
  
  private let subject: PassthroughSubject<T, Never>
  
  public init(subject: PassthroughSubject<T, Never>) {
    self.subject = subject
  }
  
  public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, T == S.Input {
    self.subject.receive(subscriber: subscriber)
  }
}
