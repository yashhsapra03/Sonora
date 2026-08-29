//
//  Song.swift
//  Sonora
//
//  Created by Yashh Sapra on 26/08/26.
//

import Foundation

struct Song: Codable, Identifiable {
    var id: Int { trackId }
    let trackId: Int
    let trackName: String
    let artistName: String
    let trackTimeMillis: Int?
    let collectionName: String?
    let artworkUrl100: String?
    let previewUrl: String?
}

struct SearchResponse: Codable {
    let resultCount: Int
    let results: [Song]
}
