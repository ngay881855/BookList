//
//  BookCollectionViewCell.swift
//  CollectionView_TableView
//
//  Created by Ngay Vong on 9/23/20.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bookImageView: UIImageView!
    
    // MARK: - UISetup/Helpers/Actions
    func configureData(item: ItemInfo) {
        guard let volumeInfo = item.volumeInfo else {
            return
        }
        if let title = volumeInfo.title {
            self.titleLabel.text = title
        }
        
        self.bookImageView.makeRoundedCorner()
        self.bookImageView.image = UIImage(named: "icons8-plus-math-50")
        if let urlString = volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
            self.bookImageView.downloadImage(with: url)
        }
    }
}
