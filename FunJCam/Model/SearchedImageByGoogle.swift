
class SearchedImageByGoogle: Decodable, SearchedImage {

    var url: String
    var pixelWidth: Double
    var pixelHeight: Double
    var thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case link
        case image
        case mime
        case displayLink
        case contextLink
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
        let metadata = try values.decodeIfPresent(Metadata.self, forKey: .image) ?? Metadata()
        self.pixelWidth = metadata.width
        self.pixelHeight = metadata.height
        self.thumbnailUrl = metadata.thumbnailLink
    }
}

private class Metadata: Decodable {
    
    var width: Double = 0
    var height: Double = 0
    var thumbnailLink: String = ""
}
