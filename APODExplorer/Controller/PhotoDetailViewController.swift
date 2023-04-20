import Foundation
import UIKit

/// Demonstrating building UI via code
class PhotoDetailViewController: UIViewController {
    init(apod: APOD, imageLoader: ImageLoader) {
        self.apod = apod
        self.imageLoader = imageLoader
        
        super.init(nibName: nil, bundle: nil)
        
        let dismissButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissDetailScreen))
        dismissButton.tintColor = .white
        navigationItem.rightBarButtonItem = dismissButton        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let apod: APOD
    private let imageLoader: ImageLoader
    private var iamgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 2
        
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.alpha = 0.6
        
        return label
    }()
    
    private var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = apod.title
        dateLabel.text = apod.date
        explanationLabel.text = apod.explanation
        
        if let imageURL = URL(string: apod.url) {
            iamgeView.load(url: imageURL, using: imageLoader)
        }
        
        setupUI()
    }
        
    private func setupUI() {
        view.backgroundColor = .white
        
        let containerView = UIView()
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        containerView.addSubview(iamgeView)
        iamgeView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iamgeView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iamgeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iamgeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            iamgeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
                        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, explanationLabel])
        textStackView.axis = .vertical

        containerView.addSubview(textStackView)
        textStackView.setCustomSpacing(24, after: dateLabel)

        textStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: iamgeView.bottomAnchor, constant: 16),
            textStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 16)
        ])        
    }
    
    @objc
    private func dismissDetailScreen() {
        dismiss(animated: true)
    }
}
