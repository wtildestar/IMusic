//
//  Search.swift
//  IMusic
//
//  Created by wtildestar on 14/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

struct SearchResponse: Decodable {
  var resultCount: Int
  var results: [Track]
}

struct Track: Decodable {
  var trackName: String
  var collectionName: String?
  var artistName: String
  var artworkUrl100: String?
  var previewUrl: String?
}
