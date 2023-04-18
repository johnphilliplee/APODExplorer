import UIKit

class APODCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(with apod: APOD) {
        if let imageURL = URL(string: apod.url) {
            imageView.load(url: imageURL)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
