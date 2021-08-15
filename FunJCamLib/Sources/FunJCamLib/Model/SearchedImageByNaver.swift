public class SearchedImageByNaver: Decodable, SearchedImage {
    
    public var url: String
    public var pixelWidth: Int
    public var pixelHeight: Int
    public var thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case link
        case sizewidth
        case sizeheight
        case thumbnail
        case title
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
        let widthString = try values.decodeIfPresent(String.self, forKey: .sizewidth)
        self.pixelWidth = Int(widthString ?? "") ?? 0
        let heightString = try values.decodeIfPresent(String.self, forKey: .sizeheight)
        self.pixelHeight = Int(heightString ?? "") ?? 0
        self.thumbnailUrl = try values.decodeIfPresent(String.self, forKey: .thumbnail) ?? ""
    }
}
