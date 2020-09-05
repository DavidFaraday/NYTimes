//
//  MyNewsViewController.swift
//  NY Times
//
//  Created by David Kababyan on 05/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit
import CoreData
import EmptyDataSet_Swift

class MyNewsViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Vars
    var newsFetchResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedNews")

    //Sets 2 cells per row in collection view
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shows empty data view when no news are stored
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self

        fetchNewsFromCD()
    }
    

    
    //MARK: - Fetch from CD
    ///fetches bookmarked news from CD and reloads collectionview
    private func fetchNewsFromCD() {
        
        let context = AppDelegate.context
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedDate", ascending: false)]
        
        newsFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        newsFetchResultsController.delegate = self
        
        do {
            try newsFetchResultsController.performFetch()
        } catch {
            fatalError("Transaction fetch error")
        }
        
        collectionView.reloadData()
    }


    //MARK: - Navigation
    ///Shows News in NewsDetail View
    /// - Parameters:
    ///   - likedNews: News to show in detail view
    private func showNews(_ likedNews: LikedNews) {
        
        let newsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "newsDetailView") as! NewsDetailViewController
        newsVc.likedNews = likedNews
        
        self.navigationController?.pushViewController(newsVc, animated: true)
    }
    
}

extension MyNewsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsFetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyNewsCollectionViewCell
        
        cell.configureCell(likedNews:  newsFetchResultsController.object(at: indexPath) as! LikedNews)
        
        return cell
    }
    
}

extension MyNewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showNews(newsFetchResultsController.object(at: indexPath) as! LikedNews)
    }
}

//used to calculate screen size and show X cells per row
extension MyNewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemsPerRow

        return CGSize(width: withPerItem, height: withPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

//updates UI when new news is bookmarked
extension MyNewsViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        collectionView.reloadData()
    }
}

//Setups empty data view (Title, image, subtitle)
extension MyNewsViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "No Bookmarked News to Display!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyNews")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Bookmarked news will appear here")
    }
    
}
