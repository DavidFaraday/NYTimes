//
//  APIRequest.swift
//  NY Times
//
//  Created by David Kababyan on 04/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NYPAPIRequest {
    
    static let shared = NYPAPIRequest()

     private let TOP_URL = "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=4flX7mxw4fT490FPgGz4lEOhKsHEZp3G"

     init() { }
    
     /// Fetch Top Stories from API
     ///
     /// - Parameters:
     ///   - completion: Returns array of News Objects.
     func fetchTopStories(completion: @escaping (_ topNews: [News]) -> Void) {
        
         AF.request(TOP_URL).responseJSON { (response) in

            let result = response.value
            var topNews: [News] = []

            if result != nil {
                
                let dataDictionary = result as! Dictionary<String, Any>

                if let newsDictionaryArray = dataDictionary["results"] as? [Dictionary<String, AnyObject>] {
                    
                    for newsDictionary in newsDictionaryArray {
                        topNews.append(News(newsDictionary))
                    }
                    
                }
            }
            
            completion(topNews)
        }
     }
}
