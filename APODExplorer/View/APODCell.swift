import UIKit

class APODCell: UICollectionViewCell {
    required init?(coder: NSCoder) {
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        super.init(coder: coder)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    private let dateFormatter: DateFormatter
    
    var downloadTask: Task<Void, Error>?
    
    override func awakeFromNib() {
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    func configure(with apod: APOD, using imageLoader: ImageLoader) {
        dateLabel.text = dateFormatter.string(from: apod.date)
        
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
