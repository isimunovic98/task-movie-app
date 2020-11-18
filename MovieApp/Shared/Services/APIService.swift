//
//  APIService.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//

import Foundation
import Alamofire

class APIService {
    
    func fetch<T: Codable>(from url: String, of: T.Type,using completion: @escaping (_ data: T?,_ status: Bool,_ message: String) -> Void) {
        AF.request(url).validate().responseData { (response) in
            guard let data = response.data else {
                completion(nil, false, "")
                return
                }
            do {
                let decodedObject: T = try JSONDecoder().decode(T.self, from: data)
                completion(decodedObject, true, "")
            } catch {
                completion(nil, false, error.localizedDescription)            }
           }
    }

}

