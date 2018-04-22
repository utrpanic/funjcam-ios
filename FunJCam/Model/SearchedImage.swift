
protocol SearchedImage {
    
    var url: String? { get }
    var pixelWidth: Double? { get }
    var pixelHeight: Double? { get }
    var thumbnailUrl: String? { get }
    
    var isAnimatedGif: Bool { get }
}
