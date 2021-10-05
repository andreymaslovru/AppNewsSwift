//
//  APICaller.swift
//  AppNewsSwift
//
//  Created by Admin on 05.10.2021.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let source: Source;
    let author: String?;
    let title: String;
    let description: String?;
    let url: String?;
    let urlToImage: String?;
    let publishedAt: String?;
    let content: String?;
}

struct Source: Codable {
    //let id: Int?;
    let name: String;
}

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=eda6154a62744b7bbad849130a7f7b6f")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Articles], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
            completion(.failure(error))
        }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

