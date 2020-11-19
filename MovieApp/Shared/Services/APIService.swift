//
//  APIService.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//

import Foundation
import Alamofire

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

}

