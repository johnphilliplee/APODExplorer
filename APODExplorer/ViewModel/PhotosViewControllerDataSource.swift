import Foundation
import UIKit

class PhotosViewControllerDataSource: NSObject, UICollectionViewDataSource {
    init(viewModel: APODViewModel, imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }
    
    private let viewModel: APODViewModel
    private let imageLoader: ImageLoader
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "APODCell", for: indexPath) as? APODCell else {
            fatalError()
        }
        if let apod = viewModel.apod(atIndex: indexPath.item) {
            cell.configure(with: apod, using: imageLoader)
        }
        
        return cell
    }
}
