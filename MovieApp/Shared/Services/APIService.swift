//
//  APIService.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//

import Foundation
import Alamofire
import Combine

class APIService {
    
    static func fetch<T: Codable>(from url: String, of: T.Type,using completion: @escaping (_ data: T?,_ message: String) -> Void) {
        AF.request(url).validate().responseData { (response) in
            guard let data = response.data else {
                completion(nil, "")
                return
                }
            do {
                let decodedObject: T = try JSONDecoder().decode(T.self, from: data)
                completion(decodedObject, "")
            } catch {
                completion(nil, error.localizedDescription)            }
           }
    }
    
    static func fetchItems<T: Codable>(from urlString: String, for: T.Type) -> AnyPublisher<T, Error>{
        guard let url = URL(string: urlString) else {
            //invalid url
            fatalError()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}

