//
//  ServiceManager.swift
//  Design Pattern
//
//  Created by Ngay Vong on 9/17/20.
//

import Foundation

class ServiceManager {
    static let manager = ServiceManager()
    
    private init() {}
    
    func request(withUrl url: URL, completed: @escaping (Any?, Error?) -> Void) {
        // uploadTask
        // downloadTask
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse, (response.statusCode == 200) else {
                DispatchQueue.main.async {
                    completed(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completed(data, nil)
                return
            }
        } // can do .resume() directly
        task.resume() // calls the service
    }
}
