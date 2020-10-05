//
//  BookListCollectionViewController.swift
//  CollectionView_TableView
//
//  Created by Ngay Vong on 9/23/20.
//

import UIKit

private let reuseIdentifier = "BookCollectionViewCell"

class BookListCollectionViewController: UICollectionViewController {
    // MARK: - IBOutlets
    
    // MARK: - Private properties
    var itemInfos: [ItemInfo] = []
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDataFromServer()
        setupUI()
    }
    
    // MARK: - UISetup/Helpers/Actions
    func setupUI() {
        self.title = "Book List"
    }
    
    func getDataFromServer() {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=coding") else { return }
        ServiceManager.manager.request(withUrl: url) { (data, error) in
            guard let dataObj = data as? Data else {
                print(error!)
                return
            }
            do {
                let responseObj = try JSONDecoder().decode(ApiResponse.self, from: dataObj)
                if let items = responseObj.items {
                    self.itemInfos = items
                    self.itemInfos.append(contentsOf: self.itemInfos)
                    self.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemInfos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as? BookCollectionViewCell  else {
            fatalError()
        }
        cell.configureData(item: itemInfos[indexPath.row])
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyBoard.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController else {
            return
        }
        detailVC.volumeInfo = itemInfos[indexPath.row].volumeInfo
        
        self.show(detailVC, sender: self)
    }
}
