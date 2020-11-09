//
//  Services.swift
//  Tickled
//
//  Created by Sachitananda Sahu on 07/11/20.
//

import Foundation
import UIKit
import Alamofire

enum APIError: String {
    case networkError
    case apiError
    case decodingError
}

enum APIs: URLRequestConvertible  {
    
    // MARK:- cases containing APIs
    case trendingMovie(query: String)
    
    // MARK:- variables
    static let endpoint = URL(string: "http://api.themoviedb.org/3")!
    static let apiKey = "65753283a9e57638fb684c5cc8ec6a5f"
    static let contenType = "application/json;charset=utf-8"
    static let connection = "keep-alive"
    static var pageCount = 1
    static let ImageBaseUrl = "https://image.tmdb.org/t/p/original"
    
    var path: String {
        switch self {
        case .trendingMovie(_):
            return "/trending/movie/week"
        default:
            return ""
        }
    }
    
    /// HTTP Method
    var method: HTTPMethod {
        return .get
    }
    
    /// Encoding
    var encoding : URLEncoding {
        return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets)
    }
    
    /// Adding API headers
    func addApiHeaders(request: inout URLRequest) {
        request.addValue(Self.contenType, forHTTPHeaderField: "content-type")
        request.addValue(Self.connection, forHTTPHeaderField: "connection")
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Self.endpoint.appendingPathComponent(path))
        var parameters = Parameters()
        
        switch self {
        case .trendingMovie(let query):
            parameters["api_key"] = query
            parameters["page"] = String(APIs.pageCount)
        default: break
        }
        
        addApiHeaders(request: &request)
        request.addValue("iphone", forHTTPHeaderField: "User-Agent")
        request = try encoding.encode(request, with: parameters)
        return request
    }
            
}

struct NetworkManager {
    let jsonDecoder = JSONDecoder()
    
    /// Calling Get API
    func getTrendingMovies(query: String, completion: @escaping([Movie]?, APIError? ) -> ()) {
        AF.request(APIs.trendingMovie(query: query)).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(nil, .apiError)
            case .success(let jsonData):
                if let payload = jsonData as? [String: Any], let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: .sortedKeys)  {
                    do {
                        /// Decoding the values
                        let list = try self.jsonDecoder.decode(MoviesList.self, from: jsonData)
                        completion(list.results, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
}
