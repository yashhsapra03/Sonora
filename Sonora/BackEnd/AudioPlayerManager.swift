//
//  AudioPlayerManager.swift
//  Sonora
//
//  Created by Yashh Sapra on 01/09/26.
//

import AVFoundation
import SwiftUI
import SwiftData

@Observable
class AudioPlayerManager {
    var queue: [Song] = []
    var currentIndex: Int = 0
    var currentSong: Song? {
        queue.isEmpty ? nil : queue[currentIndex]
    }
    var modelContext: ModelContext?
    var isPlaying = false
    var isSeeking = false
    var currentTime: Double = 0
    var duration: Double = 0
    var dominantColor: Color = .clear
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var endObserver: Any?
    
    func playSong() {
        guard let songURL = URL(string: currentSong?.previewUrl ?? "") else {
            print("Unable to play song")
            return
        }
        removeTimeObserver() // Remove the old time observer if any, before adding a new one
        removeEndObserver() // Remove the old end observer if any, before adding a new one
        player?.pause() // Pause a song if already playing
        
        
        player = AVPlayer(url: songURL)
        player?.play()
        isPlaying = true
        
        // Setting up an observer to detect when a song ends and then performs the closure to play next song automatically
        endObserver = NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem, queue: .main) { [ weak self ] _ in
            self?.playNext()
        }
        
        // Fetch the Duration of the song
        Task {
            if let item = player?.currentItem {
                let seconds = try? await item.asset.load(.duration)
                duration = seconds?.seconds ?? 0
            }
            await dominantColor(from: currentSong?.artworkUrl100 ?? "")
        }
        
        // Update Song's Current Time every 0.05 seconds for Smooth UX
        let interval = CMTime(seconds: 0.05, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [ weak self ] time in
            if self?.isSeeking == false {
                self?.currentTime = time.seconds
            }
        }
    }
    
    func playPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func playNext() {
        if !queue.isEmpty && currentIndex < queue.count - 1 {
            currentIndex += 1
        }
        playSong()
    }
    
    func playPrevious() {
        if !queue.isEmpty && currentIndex > 0 {
            currentIndex -= 1
        }
        playSong()
    }
    
    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: time)
    }
    
    func dominantColor(from imageURL: String) async {
        guard let url = URL(string: imageURL) else { return print("Unable to get image URL") }
        
        guard let data = try? await URLSession.shared.data(from: url) else { return print("Unable to get image data")}
        
        if let uiImage = UIImage(data: data.0) {
            if let ciImage = CIImage(image: uiImage) {
                let filter = CIFilter(name: "CIAreaAverage")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(ciImage.extent, forKey: kCIInputExtentKey)
                
                guard let outputImage = filter?.outputImage else { return }
                
                let context = CIContext()
                
                guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
                
                guard let pixelData = cgImage.dataProvider?.data else { return }
                
                let dataPtr = CFDataGetBytePtr(pixelData)
                
                let r = CGFloat(dataPtr?[0] ?? 0) / 255
                let g = CGFloat(dataPtr?[1] ?? 0) / 255
                let b = CGFloat(dataPtr?[2] ?? 0) / 255
                
                dominantColor = Color(red: r, green: g, blue: b)
            }
        }
        
    }
    
    func saveToRecentlyPlayed(song: Song) {
        let savedSong = RecentlyPlayedSong(trackName: song.trackName, artistName: song.artistName, artworkUrl100: song.artworkUrl100 ?? "", previewUrl: song.previewUrl ?? "", playedAt: Date())
        
        let descriptor = FetchDescriptor<RecentlyPlayedSong>(sortBy: [SortDescriptor(\.playedAt)])
        
        if let all = try? modelContext?.fetch(descriptor) {
            if let existing = all.first(where: { $0.trackName == song.trackName }) {
                existing.playedAt = Date()
            } else {
                if all.count > 10 {
                    modelContext?.delete(all.first!)
                }
                modelContext?.insert(savedSong)
            }
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    private func removeEndObserver() {
        if let observer = endObserver {
            NotificationCenter.default.removeObserver(observer)
            endObserver = nil
        }
    }
    
}
