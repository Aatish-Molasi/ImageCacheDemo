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
            pinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            pinImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            pinImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            pinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
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
            self.pinImageView.setImage(withURL: URL(string: thumbUrlString), placeholderImage: UIImage(named: "bgNoimage"), completed: nil)
        } else if let rawUrlString = pin.urls[PinAPIConstants.ImageTypes.raw.rawValue] {
            self.pinImageView.setImage(withURL: URL(string: rawUrlString), placeholderImage: UIImage(named: "bgNoimage"), completed: nil)
        }
    }

    class func getCellIdentifier() -> String {
        return String(describing: PinCell.self)
    }
}
