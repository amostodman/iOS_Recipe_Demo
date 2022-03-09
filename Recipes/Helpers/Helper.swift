//
//  Helper.swift
//  Recipes
//
//  Created by Amos Todman on 3/8/22.
//

import Foundation

struct Helper {
    static func jsonFromFile(named fileName: String) -> [String: AnyObject]? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("could not create url with filename: \(fileName)")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: AnyObject] else {
                print("could not serialize json with data: \(jsonData)")
                return nil
            }
            return json
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
        return nil
    }
}
