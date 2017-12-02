//
//  SearchedImageGridCell.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class SearchedImageGridCell: UICollectionViewCell, NibLoadable {
    
    class var defaultHeight: CGFloat { return 100 }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.borderColor = UIColor.gray.cgColor
        self.imageView.layer.borderWidth = 0.5
        self.imageView.clipsToBounds = true
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configure(searchedImage: SearchedImage?) {
        self.imageView.setImage(url: searchedImage?.thumbnailUrl, placeholder: nil, completion: nil)
    }
}
