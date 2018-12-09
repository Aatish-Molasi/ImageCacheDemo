import Foundation
import UIKit
import ImageCacheManager

class PinCell: UITableViewCell {
    @IBOutlet
    var pinImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pinImageView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func updateData(pin: Pin) {
        //We can keep falling back to other sizes and so on and so forth
//        if let thumbUrlString = pin.urls[PinAPIConstants.ImageTypes.thumb.rawValue] {
//            self.pinImageView.setImage(withURL: URL(string: thumbUrlString), placeholderImage: UIImage(named: "bgNoimage"), completed: nil)
//        } else if let rawUrlString = pin.urls[PinAPIConstants.ImageTypes.raw.rawValue] {
//            self.pinImageView.setImage(withURL: URL(string: rawUrlString), placeholderImage: UIImage(named: "bgNoimage"), completed: nil)
//        }
//    }

    class func getCellIdentifier() -> String {
        return String(describing: PinCell.self)
    }
}
