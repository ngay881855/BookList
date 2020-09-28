//
//  BookTableViewCell.swift
//  Design Pattern
//
//  Created by Ngay Vong on 9/21/20.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.selectionStyle = .none
    }
    
    // MARK: - UISetup/Helpers/Actions
    func configureData(item: ItemInfo) {
        guard let volumeInfo = item.volumeInfo else {
            return
        }
        
        if let title = volumeInfo.title {
            self.titleLabel.text = title
            self.titleLabel.isHidden = false
        } else {
            self.titleLabel.isHidden = true
        }
        
        if let subTitle = volumeInfo.subTitle {
            self.subTitleLabel.text = subTitle
            self.subTitleLabel.isHidden = false
        } else {
            self.subTitleLabel.isHidden = true
        }
        
        self.bookImageView.makeRoundedCorner()
        self.bookImageView.image = #imageLiteral(resourceName: "icons8-plus-math-50")
        if let urlString = volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
            self.bookImageView.downloadImage(with: url)
        }
    }
}

// MARK: - Extensions
extension UIImageView {
    func downloadImage(with url: URL) {
        /*
         global = background thread that is managed by the system
         need to put downloading the image on background thread,
         if we don't do this it will cause lagging when scrolling
         */
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch {
                print(error)
            }
        }
    }
    
    func makeRoundedCorner() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
