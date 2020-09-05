//
//  TodayTableViewController.swift
//  NY Times
//
//  Created by David Kababyan on 04/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit

class TodayTableViewController: UITableViewController {

    //MARK: - Vars
    var allTopNews: [News] = []
    var lastReloadDate = Date()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl

        tableView.tableFooterView = UIView()
        
        loadTopNews()
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return allTopNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodayTableViewCell

        cell.configureCell(allTopNews[indexPath.row])
        return cell
    }
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "topNewsToNewsDetailSeg", sender: indexPath)
    }

    
    //MARK: - LoadNews
    
    /// Load news from NYTAPI
    private func loadTopNews() {
        NYPAPIRequest.shared.fetchTopStories(completion: {
            allNews in
            
            self.allTopNews = allNews
            self.tableView.reloadData()
        })
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "topNewsToNewsDetailSeg" {
            let indexPath = sender as! IndexPath
            
            //Initialize and show News Detail view with selected news
            let newsDetailView = segue.destination as! NewsDetailViewController

            newsDetailView.news = allTopNews[indexPath.row]
        }
    }

    // MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if self.refreshControl!.isRefreshing {
            
            //Allows reloading news only after x amount of time
            //currently set form minutes and number is set in GlobalFunctions.swift
            if Date().interval(ofComponent: .minute, fromDate: lastReloadDate) > kRELOADTIME {
                self.loadTopNews()
                lastReloadDate = Date()
            }
            
            self.refreshControl!.endRefreshing()
        }
    }
}
