//
//  ContentView.swift
//  Sonora
//
//  Created by Yashh Sapra on 26/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var songs: [Song] = []
    @Query(sort: \RecentlyPlayedSong.playedAt, order: .reverse) var recentSongs: [RecentlyPlayedSong]
    @State private var audioManager = AudioPlayerManager()
    @State private var showingNowPlaying = false
    @State private var searchTask: Task<Void,Never>? = nil
    @State private var searchText = ""
    @Environment(\.modelContext) var modelContext
    
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
                        audioManager.queue = songs
                        audioManager.currentIndex = songs.firstIndex(where: {
                            $0.id == song.id
                        }) ?? 0
                        audioManager.playSong()
                        audioManager.saveToRecentlyPlayed(song: song)
                    }
                }
                
                if let currentSong = audioManager.currentSong {
                    NowPlayingBarView(song: currentSong, playPauseTap: audioManager.playPause, audioManager: audioManager)
                        .onTapGesture {
                            showingNowPlaying = true
                        }
                }
            }
            .searchable(text: $searchText,prompt: "Search a song")
            .searchSuggestions {
                if searchText.isEmpty {
                    //Text("Recently Played")
                    ForEach(recentSongs) { song in
                        HStack {
                            AsyncImage(url: URL(string: song.artworkUrl100)) { image in
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
                            let againPlaying = Song(trackId: 0, trackName: song.trackName, artistName: song.artistName, trackTimeMillis: nil, collectionName: nil, artworkUrl100: song.artworkUrl100, previewUrl: song.previewUrl)
                            audioManager.queue = [againPlaying]
                            audioManager.currentIndex = 0
                            audioManager.playSong()
                        }
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $showingNowPlaying) {
                if audioManager.currentSong != nil {
                    NowPlayingView(audioManager: audioManager, playPauseTap: audioManager.playPause)
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
                songs = await searchSongs(term: "judge")
            }
            .onAppear {
                audioManager.modelContext = modelContext
            }
        }
        
    }
    
    
}

#Preview {
    ContentView()
}
                                                                            
