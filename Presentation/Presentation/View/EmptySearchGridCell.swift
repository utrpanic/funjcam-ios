import UIKit

class EmptySearchGridCell: UICollectionViewCell {
  
  @IBOutlet weak var emptyLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.emptyLabel.text = "No Result"
  }   
}
