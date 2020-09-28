//
//  ViewController.swift
//  Design Pattern
//
//  Created by Ngay Vong on 9/17/20.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOulets
    @IBOutlet weak var tableView: UITableView!
    
    var itemInfos: [ItemInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDataFromServer()
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
                    self.tableView.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
    }
}

// MARK: - DELEGATE
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = SB.instantiateViewController(identifier: "BookDetailViewController") as BookDetailViewController
        detailVC.volumeInfo = itemInfos[indexPath.row].volumeInfo
        
        self.show(detailVC, sender: self)
    }
}

// MARK: - DATASOURCE
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            fatalError()
        }
        cell.configureData(item: itemInfos[indexPath.row])
        
        return cell
    }
}
