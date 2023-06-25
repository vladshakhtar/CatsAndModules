//
//  Networking.swift
//  Networking
//
//  Created by Vladislav Stolyarov on 29.05.2023.
//

import Foundation
//import FirebasePerformance

// MARK: Networking Class to load photos from API
public final class Networking {
    private let catAPIKey = "YOUR_CAT_API_KEY"
    private let dogAPIKey = "YOUR_DOG_API_KEY"
    
    public init() {}
    
    public func getCats() async throws -> [Animal] {
        let urlString = "https://api.thecatapi.com/v1/images/search?limit=10"
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(catAPIKey, forHTTPHeaderField: "x-api-key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let cats = try decoder.decode([Animal].self, from: data)
        return cats
    }
    
    public func getDogs() async throws -> [Animal] {
        let urlString = "https://api.thedogapi.com/v1/images/search?limit=10"
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(dogAPIKey, forHTTPHeaderField: "x-api-key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let dogs = try decoder.decode([Animal].self, from: data)
        return dogs
    }
}




public enum NetworkingError: Error {
    case invalidURL
    case noData
}

public struct Animal: Codable,Identifiable {
    public let id: String
    public let url: String
    
    public init(id: String, url: String) {
        self.id = id
        self.url = url
    }
}
