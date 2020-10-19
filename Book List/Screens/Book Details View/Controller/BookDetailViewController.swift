//
//  BookDetailViewController.swift
// CollectionView_TableView
//
//  Created by Ngay Vong on 9/22/20.
//

import SafariServices
import UIKit

class BookDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var bookImageView: UIImageView!

    // MARK: - Properties
    var volumeInfo: VolumeInfo?
    var bookDetailInfo: [(key: String, value: String)] = []

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        populateData()
    }

    // MARK: - UISetup/Helpers/Actions
    func setupUI() {
        self.tableView.tableFooterView = UIView()
        if let title = volumeInfo?.title {
            self.title = title
        }

        if volumeInfo?.previewLink != nil {
            let previewBarButton = UIBarButtonItem(title: "Preview", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openLink))
            self.navigationItem.rightBarButtonItem = previewBarButton
        }
    }

    @objc func openLink() {
        guard let previewLink = volumeInfo?.previewLink, let url = URL(string: previewLink) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
    }

    func populateData() {
        guard let volumeInfo = volumeInfo else { return }
        
        if let urlString = volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
            self.bookImageView.downloadImage(with: url)
        }

        convertDataToBookInfo(volumeInfo: volumeInfo)
    }
    
    func convertDataToBookInfo(volumeInfo: VolumeInfo) {
        if let subTitle = volumeInfo.subTitle {
            bookDetailInfo.append(("Subtitle", subTitle))
        }
        if let authors = volumeInfo.authors {
            bookDetailInfo.append(("Authors", authors.toString()))
        }
        if let publisher = volumeInfo.publisher {
            bookDetailInfo.append(("Publisher", publisher))
        }
        if let pageCount = volumeInfo.pageCount {
            bookDetailInfo.append(("Page count", String(pageCount)))
        }
        if let description = volumeInfo.description {
            bookDetailInfo.append(("Description", description))
        }
    }
}

// MARK: - Extensions
extension Array where Element == String {
    func toString() -> String {
        guard self.count > 1 else {
            return self[0]
        }
        var result = self[0]
        for index in 1 ..< self.count {
            result += ", \(self[index])"
        }
        return result
    }
}

extension BookDetailViewController: SFSafariViewControllerDelegate {
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//
//    }
}

// MARK: TableView Delegate
extension BookDetailViewController: UITableViewDelegate {
}

// MARK: TableView Datasource
extension BookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookDetailInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookDetailTableViewCell", for: indexPath) as? BookDetailTableViewCell else {
            fatalError("Can not dequeue BookDetailTableViewCell")
        }

        cell.configureData(with: bookDetailInfo[indexPath.row])

        return cell
    }
}
