//
//  MyNewsCollectionViewCell.swift
//  NY Times
//
//  Created by David Kababyan on 05/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit

class MyNewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    /// Configures CollectionViewCell
    ///
    /// - Parameters:
    ///   - likedNews: News object to populate the cell
    func configureCell(likedNews: LikedNews) {
        
        newsTitle.text = likedNews.title
        newsTitle.adjustsFontSizeToFitWidth = true
        newsTitle.minimumScaleFactor = 0.7

        if likedNews.thumbUrl != nil &&  likedNews.thumbUrl != "" {
            setImage(url: likedNews.thumbUrl!)
        }
    }
    
    /// Set News Image
    ///
    /// - Parameters:
    ///   - url: URL of the image to fetch
    private func setImage(url: String) {

        if let url = URL(string: url) {
            newsImageView.load(url: url)
            newsImageView.contentMode = .scaleToFill
        }
    }

}
