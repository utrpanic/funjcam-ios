//
//  SearchedImageGridCell.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class SearchedImageGridCell: UICollectionViewCell {
    
    class var defaultHeight: CGFloat { return 110 }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.drawBorder()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configureCell(_ searchedImage: SearchedImage?) {
        self.imageView.setImage(url: searchedImage?.link, placeholder: nil, completino: nil)
    }
}
