//
//  NewsDetailPresenter.swift
//  NewsApp
//
//  Created by Jaya on 27/01/25.
//

import Foundation

protocol NewsDetailView: AnyObject {
    func updateLikes(_ count: Int)
    func updateComments(_ count: Int)
    func updateArticleDetails(title: String, author: String, description: String, imageURL: String?)
}



class NewsDetailPresenter {
    private weak var view: NewsDetailView?
    private let article: Article
    
    init(view: NewsDetailView, article: Article) {
        self.view = view
        self.article = article
    }
    
    func fetchArticleDetails() {
        // Assuming the article has a URL, which is used to create an article ID for fetching likes and comments
        let articleID = article.url.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "-")
        
        fetchBasicArticleDetails()
        
        // Fetching likes and comments using the article ID
        fetchLikes(articleID)
        fetchComments(articleID)
    }
    
    private func fetchLikes(_ articleID: String) {
        guard let url = URL(string: "https://cn-news-info-api.herokuapp.com/likes/\(articleID)") else {
            print("Invalid URL for likes")
            self.view?.updateLikes(0)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch likes:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.view?.updateLikes(0)
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8),
               let count = Int(responseString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                DispatchQueue.main.async {
                    self.view?.updateLikes(count)
                }
            } else {
                print("Invalid likes response. Setting likes to 0")
                DispatchQueue.main.async {
                    self.view?.updateLikes(0)
                }
            }
        }.resume()
    }
    
    private func fetchComments(_ articleID: String) {
        guard let url = URL(string: "https://cn-news-info-api.herokuapp.com/comments/\(articleID)") else {
            print("Invalid URL for comments")
            self.view?.updateComments(0)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch comments:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.view?.updateComments(0)
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8),
               let count = Int(responseString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                DispatchQueue.main.async {
                    self.view?.updateComments(count)
                }
            } else {
                print("Invalid comments response. Setting comments to 0")
                DispatchQueue.main.async {
                    self.view?.updateComments(0)
                }
            }
        }.resume()
    }
    
    private func fetchBasicArticleDetails() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                
                let title = self.article.title
                let author = self.article.author ?? "Unknown"
                let description = self.article.description ?? "No description available"
                let imageURL = self.article.urlToImage
                self.view?.updateArticleDetails(title: title, author: author, description: description, imageURL: imageURL)
            }
        }
    }
}
