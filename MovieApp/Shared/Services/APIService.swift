//
//  APIService.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//

import Foundation
import Alamofire

class APIService {
    fileprivate var allUrl: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US&page=1"
    
    
    typealias moviesCallback = (_ movies: Movies?, _ status: Bool, _ message: String) -> Void
    
    func getAllMovies(completion: @escaping moviesCallback) {
        AF.request(self.allUrl,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil).response { (responseData) in
                    guard let data = responseData.data else {
                        completion(nil, false, "")
                        return
                    }
                    do {
                        let movies = try JSONDecoder().decode(Movies.self, from: data)
                        completion(movies, true, "")
                    } catch {
                        completion(nil, false, error.localizedDescription)            }
                   }
    }
}

