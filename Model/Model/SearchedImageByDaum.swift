
public class SearchedImageByDaum: Decodable, SearchedImage {
    
    public var url: String
    public var pixelWidth: Int
    public var pixelHeight: Int
    public var thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case image_url
        case width
        case height
        case thumbnail_url
        case collection
        case display_sitename
        case doc_url
        case datetime
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String.self, forKey: .image_url) ?? ""
        self.pixelWidth = try values.decodeIfPresent(Int.self, forKey: .width) ?? 0
        self.pixelHeight = try values.decodeIfPresent(Int.self, forKey: .height) ?? 0
        self.thumbnailUrl = try values.decodeIfPresent(String.self, forKey: .thumbnail_url) ?? ""
    }
}
