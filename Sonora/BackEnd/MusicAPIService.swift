//
//  MusicAPIService.swift
//  Sonora
//
//  Created by Yashh Sapra on 26/08/26.
//

import Foundation

func searchSongs(term: String) async -> [Song] {
    guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: "https://itunes.apple.com/search?term=\(encodedTerm)&media=music&limit=10") else {
        return []
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(SearchResponse.self, from: data)
        return response.results
    }
    catch {
        print("Error fetching songs: \(error.localizedDescription)")
        return []
    }
}
