import NaturalLanguage

import ReactorKit
import RxSwift

public class SearchReactor: Reactor {
    
    public enum Action {
        case search
        case searchMore
    }
    
    public enum Mutation {
        case search
        case searchMore
    }
    
    public enum ViewAction {
        case none
    }
    
    public struct State {
        public var query: String = "김연아"
        public var searchingGif: Bool = false
        public var images: [SearchedImage] = []
        var next: Int? = nil
        public var hasMore: Bool { return self.next != nil }
        public var viewAction: ViewAction = .none
    }
    
    let service: SearchService
    public let initialState: State
    
    init(service: SearchService) {
        self.service = service
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search:
            return Observable.just(.search)
        case .searchMore:
            return Observable.just(.searchMore)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .search:
            newState.viewAction = .none
        case .searchMore:
            newState.viewAction = .none
        }
        return newState
    }
    
    private func appendQueryForGifSearchingIfNeeded() -> String {
        guard self.currentState.searchingGif else { return self.currentState.query }
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self.currentState.query)
        if recognizer.dominantLanguage == .korean {
            return "\(self.currentState.query) 움짤"
        } else {
            return "\(self.currentState.query) gif"
        }
    }
}
