//
//  NowPlayingView.swift
//  Sonora
//
//  Created by Yashh Sapra on 30/08/26.
//

import SwiftUI

struct NowPlayingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var sliderValue: Double = 0
    var audioManager: AudioPlayerManager
    var playPauseTap: () -> Void
    var body: some View {
        VStack {
            
            //Dismiss View Button
            Button{
                dismiss()
            } label: {
                Image(systemName: "chevron.down")
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.circle)
            }
            .safeAreaPadding(.top)
            .padding(.bottom,20)
            
        
            
            // Song's Art Work
            if let currentSong = audioManager.currentSong {
                AsyncImage(url: URL(string: currentSong.artworkUrl100?.replacingOccurrences(of: "100x100bb", with: "1200x1200bb") ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 340, height: 350)
                .clipShape(.rect(cornerRadius: 20))
            
                VStack(spacing: 10){
                    // Song name and Artist name
                    HStack{
                        VStack(alignment: .leading) {
                            Text(currentSong.trackName).font(.title).bold()
                            Text(currentSong.artistName).foregroundStyle(.secondary)
                        }
                        .padding(.top,30)
                        .padding(.horizontal,15)
                        
                        Spacer()
                        
                    }
                }
                Spacer()
                
                // Progress Bar along with Timeline
                VStack(spacing: 8) {
                    Slider(value: $sliderValue, in: 0...max(audioManager.duration,1), onEditingChanged: { isSeeking in
                        audioManager.isSeeking = isSeeking
                        if !isSeeking {
                            audioManager.seek(to: sliderValue)
                        }
                    })
                    .onChange(of: audioManager.currentTime) {
                        if !audioManager.isSeeking {
                            sliderValue = audioManager.currentTime
                        }
                    }
                    
                    HStack {
                        Text(formatTime(audioManager.currentTime))
                        Spacer()
                        Text(formatTime(audioManager.duration))
                    }
                    .font(.caption)
                    
                }
                .padding(.horizontal,10)
            }
                
                
            // Media Control Buttons
            HStack(spacing: 50){
                Button {
                    audioManager.playPrevious()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 35))
                        .foregroundStyle(.blue)
                }
                
                Button{
                    playPauseTap()
                } label: {
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 50))
                        .padding()
                        .foregroundStyle(.primary)
                        //.tint(.primary)
                       // .background(.blue.opacity(0.8))
                        .clipShape(.circle)
                }
                
                Button {
                    audioManager.playNext()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 35))
                        .foregroundStyle(.blue)
                }
                
            }
            .padding()
          //  .background(.ultraThinMaterial)
            .safeAreaPadding(.bottom,70)
        }
        .background(LinearGradient(colors: [audioManager.dominantColor.opacity(0.3),audioManager.dominantColor], startPoint: .top, endPoint: .bottom))
    }
    
    func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "0:00"}
        let mins = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%d:%02d", mins,seconds)
    }
    
}

#Preview {
    
    let audioManager = AudioPlayerManager()
    
    audioManager.queue = [
        Song(trackId: 1779786209, trackName: "Wavy", artistName: "Karan Aujla", trackTimeMillis: 161000, collectionName: "Wavy - Single", artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/cd/df/5a/cddf5a8c-464e-3958-cf4a-7fac9e490aa5/5063616597178_cover.jpg/100x100bb.jpg", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/6e/d7/12/6ed71252-5ea1-e750-c32f-b022e6847471/mzaf_15658604173507661184.plus.aac.p.m4a")
        ]
    
    
   return NowPlayingView(audioManager: audioManager, playPauseTap: audioManager.playPause)
    
}
