//
//  BookDetailTableViewCell.swift
// CollectionView_TableView
//
//  Created by Ngay Vong on 9/22/20.
//

import UIKit

class BookDetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureData(with bookDetailInfo: (key: String, value: String)) {
        self.keyLabel.text = bookDetailInfo.key
        self.valueLabel.text = bookDetailInfo.value
    }
}
