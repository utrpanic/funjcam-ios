
class SearchedImageByGoogle: SearchedImage, Decodable {

    var url: String?
    var pixelWidth: Double? { return self.metadata?.pixelWidth }
    var pixelHeight: Double? { return self.metadata?.pixelHeight }
    var thumbnailUrl: String? { return self.metadata?.thumbnailUrl }
    
    var isAnimatedGif: Bool { return self.mimeType?.contains("gif") == true }
    
    private var metadata: Metadata?
    private var mimeType: String?
    private var displayLink: String?
    private var contextLink: String?
    
    private enum CodingKeys: String, CodingKey {
        case link
        case image
        case mime
        case displayLink
        case contextLink
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String.self, forKey: .link)
        self.metadata = try values.decodeIfPresent(Metadata.self, forKey: .image)
        self.mimeType = try values.decodeIfPresent(String.self, forKey: .mime)
        self.displayLink = try values.decodeIfPresent(String.self, forKey: .displayLink)
        self.contextLink = try values.decodeIfPresent(String.self, forKey: .contextLink)
    }
}

private class Metadata: Decodable {
    
    var pixelWidth: Double?
    var pixelHeight: Double?
    var byteSize: Double?
    var thumbnailUrl: String?
    var thumbnailWidth: Double?
    var thumbnailHeight: Double?
    
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case byteSize
        case thumbnailLink
        case thumbnailWidth
        case thumbnailHeight
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.pixelWidth = try values.decodeIfPresent(Double.self, forKey: .width)
        self.pixelHeight = try values.decodeIfPresent(Double.self, forKey: .height)
        self.byteSize = try values.decodeIfPresent(Double.self, forKey: .byteSize)
        self.thumbnailUrl = try values.decodeIfPresent(String.self, forKey: .thumbnailLink)
        self.thumbnailWidth = try values.decodeIfPresent(Double.self, forKey: .thumbnailWidth)
        self.thumbnailHeight = try values.decodeIfPresent(Double.self, forKey: .thumbnailHeight)
    }
}
