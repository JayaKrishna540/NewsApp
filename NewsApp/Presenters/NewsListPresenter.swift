//
//  NewsListPresenter.swift
//  NewsApp
//
//  Created by Jaya on 27/01/25.
//

import Foundation

protocol NewsListView: AnyObject {
    func showNews(_ articles: [Article])
    func showError(_ message: String)
}

class NewsListPresenter {
    private weak var view: NewsListView?
    
    init(view: NewsListView) {
        self.view = view
    }
    
    func fetchNews() {
        NetworkService.shared.fetchNews { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.view?.showNews(articles)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
