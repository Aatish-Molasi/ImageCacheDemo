import Foundation
import UIKit
import ImageCacheManager

class PinCell: UITableViewCell, ViewSetupProtocol {
    func setupViews() {
        self.contentView.addSubview(pinImageView)
    }

    func setupAppearance() {
        pinImageView.contentMode = .scaleAspectFit
    }

    func setupConstraints() {
        pinImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            pinImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            pinImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            pinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
            ]);
    }

    var pinImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        pinImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAppearance()
        setupConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pinImageView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateData(pin: Pin) {
        if let thumbUrlString = pin.urls[PinAPIConstants.ImageTypes.thumb.rawValue] {
            do {
                print("Thumbstring : \(thumbUrlString)")
                let imageData = try Data.init(contentsOf: URL(string: thumbUrlString)!)
                print("Data : \(imageData)")
                let bgImage = UIImage(data:imageData)
                self.pinImageView.image = bgImage
            } catch {
                print(error)
            }
        } else if let rawUrlString = pin.urls[PinAPIConstants.ImageTypes.raw.rawValue] {
            do {
                let imageData = try Data.init(contentsOf: URL(string: rawUrlString)!)
                var bgImage = UIImage(data:imageData)
                self.pinImageView.image = bgImage
            } catch {
                print(error)
            }

        }
    }

    class func getCellIdentifier() -> String {
        return String(describing: PinCell.self)
    }
}
