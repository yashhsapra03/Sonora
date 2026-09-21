//
//  FavouritesManager.swift
//  Sonora
//
//  Created by Yashh Sapra on 21/09/26.
//

import Foundation
import SwiftData

@Observable
class FavoritesManager {
    var favorites: [FavoriteSong] = []
    var modelContext: ModelContext?
    
    func addToFavorites(_ song: Song) {
        let newFavorite = FavoriteSong(trackName: song.trackName, artistName: song.artistName, artworkUrl100: song.artworkUrl100 ?? "", previewUrl: song.previewUrl ?? "", addedAt: Date())
        
        if !isFavorite(song) {
            modelContext?.insert(newFavorite)
        }
    }
     
    func removeFromFavorites(song: Song) {
        let predicate = #Predicate<FavoriteSong> { favorite in
            favorite.trackName == song.trackName &&
            favorite.artistName == song.artistName
        }
        
        let descriptor = FetchDescriptor(predicate: predicate)
        
        if let alreadyFavorite = try? modelContext?.fetch(descriptor) {
            if !alreadyFavorite.isEmpty {
                modelContext?.delete(alreadyFavorite[0])
            }
        }
    }
    
    func isFavorite(_ song: Song) -> Bool {
        let predicate = #Predicate<FavoriteSong> { favorite in
            favorite.trackName == song.trackName &&
            favorite.artistName == song.artistName
        }
        
        let descriptor = FetchDescriptor<FavoriteSong>(predicate: predicate)
        
        if let all = try? modelContext?.fetch(descriptor) {
            if all.isEmpty {
                return false
            } else {
                return true
            }
        }

        return false
    }
    
}
