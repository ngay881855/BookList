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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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
        // #warning Incomplete implementation, return the number of items
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
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
