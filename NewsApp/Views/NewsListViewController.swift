//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by Jaya on 27/01/25.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController, NewsListView {
    
    private var articles: [Article] = []
    private var presenter: NewsListPresenter!
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "News"
        
        presenter = NewsListPresenter(view: self)
        setupTableView()
        presenter.fetchNews()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showNews(_ articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        print("Error: \(message)")
    }
}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.configure(with: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NewsDetailViewController(article: articles[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
