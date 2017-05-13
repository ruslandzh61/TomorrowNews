//
//  ChannelPersistencyManager.swift
//  iOSPractice1
//
//  Created by Ruslan D on 18.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

class ArticleListPersistenceManager {
    private var articles = [Article]()
    
    func get() -> [Article] {
        return articles
    }
    
    func add(article: Article, index: Int = -1) {
        if (articles.count >= index && index >= 0) {
            articles.insert(article, at: index)
        } else {
            articles.append(article)
        }
    }
    
    func add(articles: [Article]) {
        self.articles.removeAll()
        self.articles.append(contentsOf: articles)
    }
    
    func remove(at: Int) {
        self.articles.remove(at: at)
    }
    
    func removeAll() {
        articles.removeAll()
    }
}
