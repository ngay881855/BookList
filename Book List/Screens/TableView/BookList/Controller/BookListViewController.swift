//
//  BookListViewController.swift
// CollectionView_TableView
//
//  Created by Ngay Vong on 9/17/20.
//

import UIKit

class BookListViewController: UIViewController {
    // MARK: - IBOulets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    var queueDownload = DispatchQueue(label: "com.CollectionView_TableView.downloadDataQueue", attributes: .concurrent)
    var itemInfos: [ItemInfo] {
        queueDownload.sync {
            return bookDataSource
        }
    }
    private var bookDataSource: [ItemInfo] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDataFromServer()
        self.title = "Book List"
        
        //getXMLFile(from: "bookInfo")
        setupUI()
    }
    
    // MARK: - UISetup
    private func setupUI() {
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Helper
    func getDataFromServer() {
        let url1 = "https://www.googleapis.com/books/v1/volumes?q=suspense"
        let url2 = "https://www.googleapis.com/books/v1/volumes?q=fiction"
        let url3 = "https://www.googleapis.com/books/v1/volumes?q=coding"
        let urls = [url1, url2, url3]
        
        downloadData(fromUrls: urls)
    }
    
    private func downloadData(fromUrls urls: [String]) {
        let myGroup = DispatchGroup()
        
        self.activityIndicator.startAnimating()
        for urlStr in urls {
            guard let url = URL(string: urlStr) else { continue }
            myGroup.enter()
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    // Decode data here
                    let responseObj = try JSONDecoder().decode(ApiResponse.self, from: data)
                    if let items = responseObj.items {
                        self.queueDownload.async(flags: .barrier) {
                            self.bookDataSource.append(contentsOf: items)
                        }
                    }
                    myGroup.leave()
                } catch {
                    print(error)
                    myGroup.leave()
                }
            }
        }
        
        myGroup.notify(queue: DispatchQueue.main) {
            // All downloading tasks in the group are completed, now reload the tableView
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    // Read and convert a property file to object
    private func getPlist<T: Decodable>(withName name: String) -> T? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"), let data = FileManager.default.contents(atPath: path) else {
            return nil
        }
        do {
            // using PropertyListSerialization
            //let dataFromList = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)
            
            let obj = try PropertyListDecoder().decode(T.self, from: data)
            return obj
        } catch let error {
            print(error)
        }
        return nil
    }
    
    // Read and convert a text file to object
    private func getTextFile(from fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else { return }
        do {
            let data = try String(contentsOfFile: path)
            let arrayOfStrings = data.components(separatedBy: ",")
            var stringArray = [String]()
            arrayOfStrings.forEach { string in
                stringArray.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            print(stringArray.toString())
        } catch let error {
            print(error)
        }
    }
    
    // Read and convert JSON file to object
    private func getJSONFile<T>(from fileName: String) -> T? where T: Decodable {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path) as Data
                let responseObj = try JSONDecoder().decode(T.self, from: jsonData)
                return responseObj
            } catch {
                print(error)
            }
            return nil
        } else {
            return nil
        }
    }
}

// MARK: UITableViewDelegate
extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(identifier: "BookDetailViewController") as BookDetailViewController
        detailVC.volumeInfo = itemInfos[indexPath.row].volumeInfo
        self.show(detailVC, sender: self)
    }
}

// MARK: UITableViewDataSource
extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            fatalError("Can not dequeue BookTableViewCell")
        }
        cell.configureData(item: itemInfos[indexPath.row])
        return cell
    }
}
