//
//  NewsDetailViewController.swift
//  NY Times
//
//  Created by David Kababyan on 05/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import CoreData

class NewsDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var bookMarkButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var imageCopyrightLabel: UILabel!
    @IBOutlet weak var imageCaptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
    //MARK: - Vars
    
    var news: News? //News object fetched from API
    var likedNews: LikedNews? //bookmarked news object saved in CD
    
    
    var newsFetchResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedNews")

    //used to detect tap on image view and show big image
    var tapGesture: UITapGestureRecognizer!

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //show view depending on what news we show (bookmarked or from API)
        if news != nil {
            setupUIForNews()
        } else if likedNews != nil {
            setupUIForLikedNews()
        }
        
        //Configures tap gesture for ImageView
        configureGestureRecognizer()
        
        //Fetch bookmarked news from CD, used to check if current news is in bookmark or now
        fetchNewsFromCD()
        
        //updates bookmarkStatus of the news
        checkBookmarkStatus()
    }
    
    //MARK: - IBActions
    @IBAction func bookmarkButtonPressed(_ sender: UIBarButtonItem) {
                
        //check if we have already bookmarked the news, if yes, we remove it, otherwise we bookmark it
        if !isNewsInBookmarkList(titleLabel.text!) {
            addNewsToBookmark()
        } else {
            removeNewsFromBookmark()
        }
        
        //updates bookmarkStatus of the news
        checkBookmarkStatus()
    }
    
    @IBAction func readFullStoryButtonPressed(_ sender: Any) {

        //gets the link of the news depending on a news type (bookmarked or from API)
        //opens webView with specific link to show full news
        if let link = news != nil ? news!.shortUrl : likedNews!.shortUrl {
            let webView = WebViewController(webLink: link)
            self.navigationController?.pushViewController(webView, animated: true)
        }
    }
    
    //MARK: - SetupUI
    /// Set UI for API News
    private func setupUIForNews() {
        
        titleLabel.text = news!.title
        subTitleLabel.text = news!.abstract
        
        authorLabel.text = news!.byline
        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.minimumScaleFactor = 0.7
        
        imageCopyrightLabel.text = "Photo by: " + news!.imageCopyright
        
        imageCaptionLabel.text = news!.imageCaption
        imageCaptionLabel.adjustsFontSizeToFitWidth = true
        imageCaptionLabel.minimumScaleFactor = 0.7

        
        publishedDateLabel.text = "Published: " + news!.publishedDate.dateMonthYear()
        updatedDateLabel.text = "Updated: " + news!.updatedDate.dateMonthYearTime()
        
        //hides imageView if there is no picture to display
        newsImageView.isHidden = news!.pictureUrl == ""

        if news!.pictureUrl != "" {
            setImage(url: news!.pictureUrl)
        }
    }
    
    /// Set UI for Bookmarked News
    private func setupUIForLikedNews() {
        
        titleLabel.text = likedNews!.title
        subTitleLabel.text = likedNews!.abstract
        authorLabel.text = likedNews!.byline
        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.minimumScaleFactor = 0.7
        
        imageCopyrightLabel.text = "Photo by: " + (likedNews!.imageCopyright ?? "")
        
        imageCaptionLabel.text = likedNews!.imageCaption
        imageCaptionLabel.adjustsFontSizeToFitWidth = true
        imageCaptionLabel.minimumScaleFactor = 0.7

        
        publishedDateLabel.text = "Published: " + (likedNews!.publishedDate ?? Date()).dateMonthYear()
        updatedDateLabel.text = "Updated: " + (likedNews!.updatedDate ?? Date()).dateMonthYearTime()
        
        newsImageView.isHidden = likedNews!.pictureUrl == ""

        if likedNews!.pictureUrl != "" {
            setImage(url: likedNews!.pictureUrl ?? "")
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

    //MARK: - Configure
    /// Configures tap gesture on NewsImageVie
    private func configureGestureRecognizer() {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(newsImageTapped))
        
        newsImageView.addGestureRecognizer(tapGesture)
        newsImageView.isUserInteractionEnabled = true
    }

    @objc func newsImageTapped() {
        showIMage()
    }
    
    //MARK: - SKPhotoBrowser
    /// Shows bigger image of selected news Image
    private func showIMage() {
        
        var images = [SKPhoto]()
        
        if let image = newsImageView.image {
            let photo = SKPhoto.photoWithImage(image)
            
            //If there is a caption, we add to image
            if let caption = news != nil ? news!.imageCaption : likedNews!.imageCaption {
                photo.caption = caption
            }
            
            images.append(photo)

            let browser = SKPhotoBrowser(photos: images)
            present(browser, animated: true, completion: {})
        }
    }

    //MARK: - CoreDate
    /// Create new LikedNews object and save to core data
    private func addNewsToBookmark() {
        
        if let news = news {
            let context = AppDelegate.context
            let likedNews = LikedNews(context: context)
            
            likedNews.byline = news.byline
            likedNews.abstract = news.abstract
            likedNews.title = news.title
            likedNews.shortUrl = news.shortUrl
            likedNews.thumbUrl = news.thumbUrl
            likedNews.pictureUrl = news.pictureUrl
            likedNews.imageCaption = news.imageCaption
            likedNews.imageCopyright = news.imageCopyright
            likedNews.publishedDate = news.publishedDate
            likedNews.updatedDate = news.updatedDate
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    /// Deletes Bookmarked news from core data
    private func removeNewsFromBookmark() {
        
        if let newsToDelete = getLikedNewsToDelete(titleLabel.text!) {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(newsToDelete)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }

    ///Fetches Bookmarked news from core data
    private func fetchNewsFromCD() {
        
        let context = AppDelegate.context
        
        fetchRequest.sortDescriptors = [ ]
        
        newsFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        newsFetchResultsController.delegate = self
        
        do {
            try newsFetchResultsController.performFetch()
        } catch {
            fatalError("Transaction fetch error")
        }
    }
    
    //MARK: - Helpers
    ///Check if the news is bookmarked and update bookmark button image
    private func checkBookmarkStatus() {

        let title = news != nil ? news!.title : likedNews!.title
        self.bookMarkButtonOutlet.image = UIImage(systemName:"bookmark")

        for item in newsFetchResultsController.fetchedObjects as! [LikedNews] {
            if item.title == title {
                self.bookMarkButtonOutlet.image = UIImage(systemName:"bookmark.fill")
            }
        }
    }

    ///Check if the news is bookmarked
    /// - Parameters:
    ///   - newsTitle: Title to compare
    ///   - returns: true if the news is bookmarked
    private func isNewsInBookmarkList(_ newsTitle: String) -> Bool {
        
        for news in newsFetchResultsController.fetchedObjects as! [LikedNews] {
            if news.title == newsTitle {
                return true
            }
        }
        
        return false
    }
    
    ///Return LikedNews object from CD
    /// - Parameters:
    ///   - newsTitle: Title to compare
    ///   - returns: news object from CD
    private func getLikedNewsToDelete(_ newsTitle: String) -> LikedNews? {
        
        for news in newsFetchResultsController.fetchedObjects as! [LikedNews] {
            if news.title == newsTitle {
                return news
            }
        }
        
        return nil
    }
}


extension NewsDetailViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

    }
}

