//
//  TodayTableViewCell.swift
//  NY Times
//
//  Created by David Kababyan on 04/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedTimeLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
        
    //MARK: - ViewLifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //MARK: - Configuration
    /// Configures CollectionViewCell
    ///
    /// - Parameters:
    ///   - news: News object to populate the cell
    func configureCell(_ news: News) {
        
        titleLabel.text = news.title
        publishedTimeLabel.text = news.publishedDate.dateMonthYearTime()
        
        newsImageView.isHidden = news.thumbUrl == ""
        
        if news.thumbUrl != "" {
            setImage(url: news.thumbUrl)
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
