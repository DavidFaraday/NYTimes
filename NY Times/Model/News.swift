//
//  News.swift
//  NY Times
//
//  Created by David Kababyan on 04/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import Foundation
import SwiftyJSON

struct News {
    
    var byline = ""
    var abstract = ""
    var title = ""
    var shortUrl = ""
    var thumbUrl = ""
    var pictureUrl = ""
    var imageCaption = ""
    var imageCopyright = ""

    var updatedDate = Date()
    var publishedDate = Date()
    
    init(_ newsDictionary: Dictionary<String, AnyObject>) {
        
        let json = JSON(newsDictionary)

        byline = json["byline"].stringValue
        abstract = json["abstract"].stringValue
        title = json["title"].stringValue
        shortUrl = json["short_url"].stringValue
        updatedDate = dateFrom(timestamp: json["updated_date"].stringValue)
        publishedDate = dateFrom(timestamp: json["published_date"].stringValue)
        
        setMediaURLs(json["multimedia"].arrayValue)
    }
    
    private mutating func setMediaURLs(_ multimediaItems: [JSON]) {
        
        for item in multimediaItems {
            if item["format"].stringValue == "mediumThreeByTwo210" {
                thumbUrl = item["url"].stringValue
                imageCaption = item["caption"].stringValue
                imageCopyright = item["copyright"].stringValue

            } else if item["format"].stringValue == "superJumbo" {
                pictureUrl = item["url"].stringValue
            }
        }
    }
}
