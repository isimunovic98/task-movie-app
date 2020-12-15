//
//  APIService.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//

import Foundation
import Alamofire
import Combine

enum NetworkError: Error {
    case jsonDecodingError(error: Error)
}

class APIService {
    
    static func fetchItems<T: Codable>(from urlString: String, as type: T.Type) -> AnyPublisher<T, Error>{
        guard let url = URL(string: urlString) else {
            let error = URLError(.badURL, userInfo: [NSURLErrorKey: urlString])
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { result -> T in
                return try JSONDecoder().decode(T.self, from: result.data)
            }
            .catch { error in
                return Fail(error: NetworkError.jsonDecodingError(error: error))
            }
            .eraseToAnyPublisher()
    }
}

