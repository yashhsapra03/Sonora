//
//  ContentView.swift
//  Sonora
//
//  Created by Yashh Sapra on 26/08/26.
//

import SwiftUI

struct ContentView: View {
    @State private var songs: [Song] = []
    @State private var audioManager = AudioPlayerManager()
    @State private var showingNowPlaying = false
    
    @State private var searchTask: Task<Void,Never>? = nil
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom){
                List(songs){ song in
                    HStack {
                        AsyncImage(url: URL(string: song.artworkUrl100 ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.rect(cornerRadius: 10))
                        
                        VStack(alignment: .leading){
                            Text(song.trackName)
                                .bold()
                                .padding(.bottom,-2)
                            Text(song.artistName)
                                .bold()
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onTapGesture {
                        audioManager.playSong(song: song)
                    }
                }
                
                if let currentSong = audioManager.currentSong {
                    NowPlayingBarView(song: currentSong,isPlaying: $audioManager.isPlaying, playPauseTap: audioManager.playPause)
                        .onTapGesture {
                            showingNowPlaying = true
                        }
                }
            }
            .searchable(text: $searchText,prompt: "Search a song")
            .fullScreenCover(isPresented: $showingNowPlaying) {
                if let currentSong = audioManager.currentSong {
                    NowPlayingView(song: currentSong, isPlaying: $audioManager.isPlaying, playPauseTap: audioManager.playPause)
                }
            }
            .onChange(of: searchText) {
                searchTask?.cancel()
                
                searchTask = Task {
                    try? await Task.sleep(for: .seconds(0.5))
                    
                    guard !Task.isCancelled else { return }
                    
                    let results = await searchSongs(term: searchText)
                    
                    guard !Task.isCancelled else { return }
                    
                    songs = results
                }
            }
            .navigationTitle("Sonora")
            .task {
                songs = await searchSongs(term: "Karan Aujla")
            }
        }
        
    }
    
    
}

#Preview {
    ContentView()
}
