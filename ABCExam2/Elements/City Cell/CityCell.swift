import UIKit

final class CityCell: UITableViewCell {
    
    static let cellName = "CityCell"
    
    // MARK: - UI Properties
    
    let cityImageView: UIImageView = {
        let imageView = UIImageView().disableAutoresizingMask()
        return imageView
    }()
}
