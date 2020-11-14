//
//  APIService.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//

import Foundation
import Alamofire

class APIService {
    var allUrl: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US&page=1"
    fileprivate var baseUrl = ""
    
    typealias moviesCallback = (_ movies: Movies?, _ status: Bool, _ message: String) -> Void
    var callback: moviesCallback?
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getAllMovies() {
        AF.request(self.allUrl,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil).response { (responseData) in
            guard let data = responseData.data else {
                self.callback?(nil, false, "")
                return
            }
            do {
                let movies = try JSONDecoder().decode(Movies.self, from: data)
                self.callback?(movies, true, "")
            } catch {
                self.callback?(nil, false, error.localizedDescription)            }
        }
    }
    
    func completionHandler(callback: @escaping moviesCallback) {
        self.callback = callback
    }
}
