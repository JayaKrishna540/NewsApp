//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Jaya on 27/01/25.
//

import Foundation

import UIKit

class NewsDetailViewController: UIViewController {
    
    private let article: Article
    private var presenter: NewsDetailPresenter!
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
        presenter = NewsDetailPresenter(view: self, article: article)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.fetchArticleDetails()
        setupUI()
    }
    
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(likesLabel)
        view.addSubview(commentsLabel)
        view.addSubview(activityIndicator)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            imageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 240),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            likesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            commentsLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8),
            commentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
}


extension NewsDetailViewController: NewsDetailView {
    
    func updateLikes(_ count: Int) {
        DispatchQueue.main.async {
            self.likesLabel.text = "Likes: \(count)"
        }
    }
    
    func updateComments(_ count: Int) {
        DispatchQueue.main.async {
            self.commentsLabel.text = "Comments: \(count)"
        }
    }
    
    func updateArticleDetails(title: String, author: String, description: String, imageURL: String?) {
        titleLabel.text = title
        authorLabel.text = "By: \(author)"
        descriptionLabel.text = description
        
        if let imageURLString = imageURL, let url = URL(string: imageURLString) {
            activityIndicator.startAnimating()
            imageView.loadImage(from: url) { success in
                self.activityIndicator.stopAnimating()
            }
        } else {
            imageView.image = UIImage(named: "default_image")
            activityIndicator.stopAnimating()
        }
    }
    
}

extension UIImageView {
    func loadImage(from url: URL, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false) 
                }
            }
        }
    }
}


