//
//  RecentlyPlayedSong.swift
//  Sonora
//
//  Created by Yashh Sapra on 17/09/26.
//

import Foundation
import SwiftData

@Model
class RecentlyPlayedSong {
    var trackName: String
    var artistName: String
    var artworkUrl100: String
    var previewUrl: String
    var playedAt: Date
    
    init(trackName: String, artistName: String, artworkUrl100: String, previewUrl: String, playedAt: Date) {
        self.trackName = trackName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
        self.playedAt = playedAt
    }
}
