//
//  NetworkManager.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 12.06.2019.
//  Copyright © 2019 Emre HAVAN. All rights reserved.
//

import Foundation

// Types
enum Result<T: Codable> {
    case success(object: T?)
    case error(Error)
}

typealias ResultCallback<T: Codable> = (Result<T>) -> Void

enum NetworkStackError: String, Error {
    case invalidRequest = "Invalid Request!"
    case dataMissing = "Data is missing!"
    case tokenMissing = "Authentication token is missing!"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// Endpoint
protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var httpMethod: HTTPMethod { get }
    var request: URLRequest? { get }
    var requestHeaders: [String: String]? { get }
    var requestBody: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}

// Webservice
protocol WebserviceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>)
}

final class NetworkManager: WebserviceProtocol {
    
    private let urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    private let parser: Parser = Parser()
    
    static let shared = NetworkManager()
    
    private init() { }
    
    enum Constants {
        static let host = "api.flickr.com"
        static let apiKey = "acd810ba1b25a8400db16aece0142856"
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>) {
        
        guard let request = endpoint.request else {
            OperationQueue.main.addOperation({ completion(.error(NetworkStackError.invalidRequest)) })
            return
        }

        let task = urlSession.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                OperationQueue.main.addOperation({ completion(.error(error)) })
                return
            }
            
            guard let data = data else {
                OperationQueue.main.addOperation({ completion(.error(NetworkStackError.dataMissing)) })
                return
            }
            
            self.parser.json(data: data, endpoint, completion: completion)
        }
        
        task.resume()
    }
}

struct Parser {
    let jsonDecoder = JSONDecoder()
    func json<T: Decodable>(data: Data, _ endpoint: Endpoint, completion: @escaping ResultCallback<T>) {
        do {
            let responseModel = try jsonDecoder.decode(T.self, from: data)
            OperationQueue.main.addOperation { completion(.success(object: responseModel)) }
        } catch let error {
            print(error)
        }
    }
}

extension Endpoint {
    var scheme: String {
        return "http"
    }
    
    var host: String {
        return NetworkManager.Constants.host
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var requestBody: [String: Any]? {
        return nil
    }
    
    var requestHeaders: [String: String]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    func request(forPath path: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let requestBody = requestBody {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        }
        if let headers = requestHeaders {
            for (key,value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
