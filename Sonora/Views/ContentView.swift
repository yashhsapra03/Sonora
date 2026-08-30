//
//  ContentView.swift
//  Sonora
//
//  Created by Yashh Sapra on 26/08/26.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var songs: [Song] = []
    @State private var currentSong: Song?
    @State private var isPlaying = false
    @State private var showingNowPlaying = false
    @State private var player: AVPlayer?
    @State private var searchTask: Task<Void,Never>? = nil
    @State private var callCount = 0
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
                        playSong(song: song)
                    }
                }
                
                if let currentSong {
                    NowPlayingBarView(song: currentSong,isPlaying: $isPlaying, playPauseTap: playPause)
                        .onTapGesture {
                            showingNowPlaying = true
                        }
                }
            }
            .searchable(text: $searchText,prompt: "Search a song")
            .fullScreenCover(isPresented: $showingNowPlaying) {
               NowPlayingView(song: currentSong!, isPlaying: $isPlaying, playPauseTap: playPause)
            }
            .onChange(of: searchText) {
                searchTask?.cancel()
                
                searchTask = Task {
                    try? await Task.sleep(for: .seconds(0.5))
                    
                    if !Task.isCancelled {
                        songs = await searchSongs(term: searchText)
                    }
                }
            }
            .navigationTitle("Sonora")
            .task {
                songs = await searchSongs(term: "Karan Aujla")
            }
        }
        
    }
    
    func playSong(song: Song) {
        
        guard let songURL = URL(string: song.previewUrl ?? "") else {
            print("Unable to play the song")
            return
        }
        
        player?.pause()
        player = AVPlayer(url: songURL)
        player?.play()
        currentSong = song
        isPlaying = true
    }
    
    func playPause() {
        isPlaying.toggle()
        
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }
}

#Preview {
    ContentView()
}
