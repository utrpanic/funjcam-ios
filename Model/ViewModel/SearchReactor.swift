import NaturalLanguage

import ReactorKit
import RxSwift

public class SearchReactor: Reactor {
    
    public enum Action {
        case searchQueryUpdated(String)
        case setSearchProvider(SearchProvider)
        case search
        case searchMore
    }
    
    public enum Mutation {
        case searchQueryUpdated(String)
        case setSearchProvider(SearchProvider)
        case searchBegin
        case searchResponse([SearchedImage], Int?)
        case searchError(Code)
        case searchEnd
        case searchMoreBegin
        case searchMoreResponse([SearchedImage], Int?)
        case searchMoreError(Code)
        case searchMoreEnd
    }
    
    public enum ViewAction: Equatable {
        case none
        case refresh
        case searchBegin
        case searchError(Code)
        case searchEnd
        case searchMoreBegin
        case searchMoreError(Code)
        case searchMoreEnd
    }
    
    public struct State {
        public var provider: SearchProvider {
            get { return Settings.shared.searchProvider }
            set { Settings.shared.searchProvider = newValue }
        }
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
        case let .searchQueryUpdated(query):
            return Observable.just(.searchQueryUpdated(query))
        case let .setSearchProvider(provider):
            return Observable.just(.setSearchProvider(provider))
                .concat(Observable.just(.searchBegin))
                .concat(self.search())
                .concat(Observable.just(.searchEnd))
        case .search:
            return Observable.just(.searchBegin)
                .concat(self.search())
                .concat(Observable.just(.searchEnd))
        case .searchMore:
            return Observable.just(.searchMoreBegin)
            .concat(self.searchMore())
            .concat(Observable.just(.searchMoreEnd))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .searchQueryUpdated(query):
            newState.query = query
            newState.viewAction = .none
        case let .setSearchProvider(provider):
            newState.provider = provider
            newState.images = []
            newState.next = nil
            newState.viewAction = .refresh
        case .searchBegin:
            newState.viewAction = .searchBegin
        case let .searchResponse(images, pivot):
            newState.images = images
            newState.next = pivot
            newState.viewAction = .refresh
        case let .searchError(code):
            newState.viewAction = .searchError(code)
        case .searchEnd:
            newState.viewAction = .searchEnd
        case .searchMoreBegin:
            newState.viewAction = .searchMoreBegin
        case let .searchMoreResponse(images, pivot):
            newState.images.append(contentsOf: images)
            newState.next = pivot
            newState.viewAction = .refresh
        case let .searchMoreError(code):
            newState.viewAction = .searchMoreError(code)
        case .searchMoreEnd:
            newState.viewAction = .searchMoreEnd
        }
        return newState
    }
    
    private func search() -> Observable<Mutation> {
        let query = self.currentState.query
        let provider = self.currentState.provider
        let pivot: Int? = nil
        return self.service.search(query: query, pivot: pivot, from: provider)
            .flatMap { (images, pivot) -> Observable<Mutation> in
                return Observable.just(.searchResponse(images, pivot))
            }
            .catchError { (error) -> Observable<Mutation> in
                let code = (error as? ApiError)?.code ?? .empty
                return Observable.just(.searchError(code))
            }
    }
    
    private func searchMore() -> Observable<Mutation> {
        let query = self.currentState.query
        let provider = self.currentState.provider
        let pivot = self.currentState.next
        return self.service.search(query: query, pivot: pivot, from: provider)
            .flatMap { (images, pivot) -> Observable<Mutation> in
                return Observable.just(.searchMoreResponse(images, pivot))
            }
            .catchError { (error) -> Observable<Mutation> in
                let code = (error as? ApiError)?.code ?? .empty
                return Observable.just(.searchMoreError(code))
            }
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
