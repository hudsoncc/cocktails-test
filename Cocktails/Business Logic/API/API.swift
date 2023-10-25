//
//  API.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

protocol APIService {
    func fetchDrinks(forQuery searchQuery: String) async throws -> API.Model.Drinks
    func enqueueRequest<T:Decodable>(_ request: URLRequest) async throws -> T
    func newRequest(_ method: API.HTTPMethod, toEndpoint endpoint: API.Endpoint, params: [URLQueryItem]) -> URLRequest
}

class API: APIService {

    // MARK: Enums

    enum HTTPMethod: String {
        case GET
    }

    // MARK: Fetch
    
    public func fetchDrinks(forQuery searchQuery: String) async throws -> Model.Drinks {
        let params = [
            URLQueryItem(name: Endpoint.Parameters.search.rawValue, value: searchQuery)
        ]
        let request = newRequest(.GET, toEndpoint: .search, params: params)
        return try await enqueueRequest(request)
    }
    
    // MARK: Helpers
    
    internal func enqueueRequest<T:Decodable>(_ request: URLRequest) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in

            let op = NetworkOperation(request: request) { (result: Result<T, Error>) in
                switch result {
                case .success(let model):
                    continuation.resume(returning: model)
                case .failure(let error):
                    debugPrint("Endpoint fetch failed with error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
            NetworkQueue.shared.enqueue(op)
        }
        
    }
    
    internal func newRequest(_ method: HTTPMethod, toEndpoint endpoint: Endpoint, params: [URLQueryItem]) -> URLRequest {
        var urlComps = URLComponents(url: endpoint.urlValue, resolvingAgainstBaseURL: false)!
        urlComps.queryItems = params
                
        var request = URLRequest(url: urlComps.url!)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
