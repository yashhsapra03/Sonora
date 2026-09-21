//
//  FavoriteSong.swift
//  Sonora
//
//  Created by Yashh Sapra on 21/09/26.
//

import Foundation
import SwiftData

@Model
class FavoriteSong {
    var trackName: String
    var artistName: String
    var artworkUrl100: String
    var previewUrl: String
    var addedAt: Date
    
    init(trackName: String, artistName: String, artworkUrl100: String, previewUrl: String, addedAt: Date) {
        self.trackName = trackName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
        self.addedAt = addedAt
    }
}
