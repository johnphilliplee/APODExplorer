import UIKit

class APODCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(with apod: APOD, using imageLoader: ImageLoader) {
        if let imageURL = URL(string: apod.url) {
            imageView.load(url: imageURL, using: imageLoader)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}

extension UIImageView {
    func load(url: URL, using imageLoader: ImageLoader) {
        Task {
            image = try await imageLoader.image(for: url)
        }
    }
}
