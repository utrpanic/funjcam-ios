//
//  SearchViewModel.swift
//  FunJCamViewModel
//
//  Created by BoxJeon on 13/04/2019.
//  Copyright © 2019 the42apps. All rights reserved.
//

import RxSwift

public class SearchViewModel {
    
    var images: [SearchedImage] = [SearchedImage]()
    private var query: String = ""
    private var next: Int?
    var hasMore: Bool { return self.next != nil }
    
    let updatedStream: PublishSubject<Code> = PublishSubject<Code>()
    
    private let service: SearchServiceProtocol
    
    init(service: SearchServiceProtocol) {
        self.service = service
    }
    
    public func updateQuery(_ query: String) {
        
    }
    
    public func search() {
        
    }
}
