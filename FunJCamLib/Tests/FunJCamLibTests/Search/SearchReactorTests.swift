import XCTest

@testable import FunJCamLib
import RxSwift

class SearchReactorTests: XCTestCase {
    
    var sut: SearchReactor!
    var mockApi: SearchApiMock {
        return self.sut.service.api as! SearchApiMock
    }
    var result: [SearchReactor.ViewAction] = []
    var disposeBag: DisposeBag = DisposeBag()

    override func setUp() {
        let mockApi = SearchApiMock()
        self.sut = SearchReactor()
        self.sut.service.api = mockApi
        self.sut.state.subscribe(onNext: { [weak self] (state) in
            guard let self = self else { return }
            self.result.append(state.viewAction)
        }).disposed(by: self.disposeBag)
    }

    override func tearDown() {
        // do nothing.
    }

    func testSearchFromDefaultProvider() {
        // given
        XCTAssertEqual(self.result, [
            .none
        ])
        self.result.removeAll()
        
        // when
        let query = "김연아"
        sut.action.onNext(.searchQueryUpdated(query))
        // then
        XCTAssertEqual(self.result, [
            .none
            ]
        )
        XCTAssertEqual(query, sut.currentState.query)
        self.result.removeAll()
        
//        self.mockApi.json = "LibraryHome"
//        sut.action.onNext(.search)
//        // then
//        XCTAssertEqual(self.result, [
//            .none,
//            .searchBegin,
//            .refresh,
//            .searchEnd
//            ]
//        )
    }
}
