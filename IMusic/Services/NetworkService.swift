//
//  NetworkService.swift
//  IMusic
//
//  Created by wtildestar on 14/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Alamofire

class NetworkService {
  func fetchTracks(searchText: String, completion: @escaping (Search?) -> Void) {
    let url = "https://itunes.apple.com/search"
    let params = ["term": "\(searchText)",
      "limit": "10",
      "media": "music"]
    
    AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseData { dataResponse in
      if let error = dataResponse.error {
        print("Error received requestion data: \(error.localizedDescription)")
        completion(nil)
        return
      }
      
      guard let data = dataResponse.data else { return }
      
      let decoder = JSONDecoder()
      do {
        let objects = try decoder.decode(Search.self, from: data)
        print("objects", objects)
        completion(objects)
      } catch let jsonError {
        print("Failed to decode json", jsonError)
        completion(nil)
      }
    }
  }
}
