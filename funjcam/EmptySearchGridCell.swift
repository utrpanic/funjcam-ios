//
//  EmptySearchGridCell.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 22..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class EmptySearchGridCell: UICollectionViewCell {
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.emptyLabel.text = LocalizedString("search:no_result")
    }
}
