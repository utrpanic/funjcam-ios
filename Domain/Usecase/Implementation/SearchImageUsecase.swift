import Foundation
import Entity
import HTTPNetwork
import Usecase

public final class SearchImageUsecaseImp: SearchImageUsecase {
  
  private let network: HTTPNetwork
  
  public init(network: HTTPNetwork) {
    self.network = network
  }
  
  public func execute(query: String, next: Int?, provider: SearchProvider) async throws -> SearchImageResult {
    switch provider {
    case .daum:
      let result = try await self.searchDaum(query: query, next: next)
      return SearchImageResult(images: result.searchedImages, next: result.next)
    case .google:
      let result = try await self.searchGoogle(query: query, next: next)
      return SearchImageResult(images: result.searchedImages, next: result.next)
    case .naver:
      let result = try await self.searchNaver(query: query, next: next)
      return SearchImageResult(images: result.searchedImages, next: result.next)
    }
  }
  
  private func searchDaum(query: String, next: Int?) async throws -> DaumSearchImageResult {
    let params = HTTPGetParams(
        url: URL(string: "https://dapi.kakao.com/v2/search/image"),
        headers: [
          "Authorization": "KakaoAK 3aa0ae0423487ecc4eda2664cc7bc936"
        ],
        queries: [
          "query": query,
          "sort": "accuracy", // accuracy or recency
          "page": next, // 1 ~ 50
          "size": "20" // 1 ~ 80
        ]
    )
    let responseBody = try await self.network.get(with: params).body
    let decoder = JSONDecoder()
    decoder.userInfo[DaumSearchImageResult.currentPage] = next ?? 1
    return try decoder.decode(DaumSearchImageResult.self, from: responseBody)
  }
  
  private func searchGoogle(query: String, next: Int?) async throws -> GoogleImageSearchResult {
    let params = HTTPGetParams(
      url: URL(string: "https://www.googleapis.com/customsearch/v1"),
      headers: nil,
      queries: [
        "q": query,
        "key": "AIzaSyCTdQn7PY1xP5d_Otz8O8aTvbCSslU7lBQ",
        "cx": "015032654831495313052:qzljc0expde",
        "searchType": "image",
        "start": next,
        "num": 10 // 1~10만 허용.
      ]
    )
    let responseBody = try await self.network.get(with: params).body
    return try JSONDecoder().decode(GoogleImageSearchResult.self, from: responseBody)
  }
  
  private func searchNaver(query: String, next: Int?) async throws -> NaverSearchImageResult {
    let params = HTTPGetParams(
      url: URL(string: "https://openapi.naver.com/v1/search/image"),
      headers: [
        "X-Naver-Client-Id": "93Aki4p3ckUPf2L7Lyac",
        "X-Naver-Client-Secret": "wD6dHhbcSs"
      ],
      queries: [
        "query": query,
        "sort": "sim", // sim or date
        "start": next, // 1 ~ 1000
        "display": "20", // 10 ~ 100
        "filter": "all" // all, large, medium, small
      ]
    )
    let responseBody = try await self.network.get(with: params).body
    return try JSONDecoder().decode(NaverSearchImageResult.self, from: responseBody)
  }
}
