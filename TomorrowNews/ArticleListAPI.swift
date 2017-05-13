//
//  ChannelAPI.swift
//  iOSPractice1
//
//  Created by Ruslan D on 21.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

enum ArticleListType {
    case channel
    case related
    case collection
    case history
    case offline
}

class ArticleListAPI: NSObject {
    
    private let connector: ArticleListConnector
    private let persistenceManager: ArticleListPersistenceManager
    private let type: ArticleListType
    
    init(type: ArticleListType) {
        self.connector = ArticleListConnector()
        self.persistenceManager = ArticleListPersistenceManager()
        self.type = type
        super.init()
    }
    
    func load(params: [String: String], isPersonalized: Bool = false,
                      completionHandlerForUI: @escaping () -> ()) {
        switch self.type {
        case ArticleListType.channel:
            self.loadChannelArticles(params: params, isPersonalized: isPersonalized,
                    completionHandlerForUI: completionHandlerForUI)
        case ArticleListType.related:
            self.loadRelatedArticles(params: params,
                    completionHandlerForUI: completionHandlerForUI)
        default: break
        }
    }
    
    func get() -> [Article] {
        return persistenceManager.get()
    }
    
    func add(article: Article, at: Int = -1) {
        persistenceManager.add(article: article, index: at)
        //connector.add(article)
    }
    
    func remove(at: Int) {
        persistenceManager.remove(at: at)
        //connector.remove(at: at)
    }
    
    private func loadChannelArticles(params: [String: String], isPersonalized: Bool,
                    completionHandlerForUI: @escaping () -> ()) {
        self.connector.loadArticlesByFeed(params: params, isPersonalized: isPersonalized, completionHandler: {
            articles in
            
            self.persistenceManager.add(articles: articles)
            print("articles count in persmanager: \(articles.count)")
            completionHandlerForUI()
        })
    }
    
    private func loadRelatedArticles(params: [String: String],
                    completionHandlerForUI: @escaping () -> ()) {
        self.connector.loadRelatedArticles(params: params, completionHandler: {
            articles in
            
            self.persistenceManager.add(articles: articles)
            print("articles count in persmanager: \(articles.count)")
            completionHandlerForUI()
        })
    }
}
