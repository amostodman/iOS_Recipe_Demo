//
//  Network.swift
//  Recipes
//
//  Created by Amos Todman on 3/8/22.
//

import UIKit

class Network: NSObject {
    
    class func post(url: URL, params: [String: String]?, completion: (([String: AnyObject]) -> Void)?) {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        if let params = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                guard let data = data else {
                    print("response data was nil")
                    return
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject] else {
                    print("could not serialize json with data: \(data)")
                    return
                }
                
                completion?(json)
            } catch {
                print("error: \(error.localizedDescription)")
            }
        })
        
        task.resume()
    }
    
    class func downloadImage(from url: URL, completion: ((UIImage?) -> Void)?) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else {
                print("could not create image from data: \(data)")
                return
            }
            
            completion?(image)
        }
    }
    
    class func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
