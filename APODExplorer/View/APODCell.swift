import UIKit

class APODCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var downloadTask: Task<Void, Error>?
    
    override func awakeFromNib() {
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(with apod: APOD, using imageLoader: ImageLoader) {
        if let imageURL = URL(string: apod.url) {
            downloadTask = Task {                
                let image = try await imageLoader.image(for: imageURL)
                try Task.checkCancellation()
                imageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        imageView.image = nil
    }
}
