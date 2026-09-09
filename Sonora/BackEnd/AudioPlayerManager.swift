//
//  AudioPlayerManager.swift
//  Sonora
//
//  Created by Yashh Sapra on 01/09/26.
//

import AVFoundation

@Observable
class AudioPlayerManager {
    var queue: [Song] = []
    var currentIndex: Int = 0
    var currentSong: Song? {
        queue.isEmpty ? nil : queue[currentIndex]
    }
    var isPlaying = false
    var isSeeking = false
    var currentTime: Double = 0
    var duration: Double = 0
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    func playSong() {
        guard let songURL = URL(string: currentSong?.previewUrl ?? "") else {
            print("Unable to play song")
            return
        }
        removeTimeObserver() // Remove the old observer if any, before adding a new one
        player?.pause() // Pause a song if already playing
        
        player = AVPlayer(url: songURL)
        player?.play()
        isPlaying = true
        
        // Fetch the Duration of the song
        Task {
            if let item = player?.currentItem {
                let seconds = try? await item.asset.load(.duration)
                duration = seconds?.seconds ?? 0
            }
        }
        
        // Update Song's Current Time every 0.5 seconds for Smooth UX
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
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
}
