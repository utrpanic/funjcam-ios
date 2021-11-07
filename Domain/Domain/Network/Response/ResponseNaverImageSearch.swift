import Entity

class ResponseNaverImageSearch: Decodable {
    
    var searchedImages: [SearchedImageByNaver]
    var nextStartIndex: Int?
    
    private enum CodingKeys: String, CodingKey {
        case items
        case display
        case total
        case start
        case lastBuildDate
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.searchedImages = try values.decodeIfPresent([SearchedImageByNaver].self, forKey: .items) ?? []
        let startIndex = try values.decodeIfPresent(Int.self, forKey: .start)
        if let startIndex = startIndex, self.searchedImages.hasElement {
            self.nextStartIndex = startIndex + self.searchedImages.count
        }
    }
}
