//
//  AudioPlayerManager.swift
//  Sonora
//
//  Created by Yashh Sapra on 01/09/26.
//

import AVFoundation

@Observable
class AudioPlayerManager {
    var currentSong: Song?
    var isPlaying = false
    var currentTime: Double = 0
    var duration: Double = 0
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    func playSong(song: Song) {
        guard let songURL = URL(string: song.previewUrl ?? "") else {
            print("Unable to play song")
            return
        }
        removeTimeObserver() // Remove the old observer if any, before adding a new one
        player?.pause() // Pause a song if already playing
        
        player = AVPlayer(url: songURL)
        player?.play()
        currentSong = song
        isPlaying = true
        
        // Fetch the Duration of the song
        Task {
            if let item = player?.currentItem {
                let seconds = try? await item.asset.load(.duration)
                duration = seconds?.seconds ?? 0
            }
        }
        
        // Update Song's Current Time every 0.5 seconds for Smooth UX
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [ weak self ] time in
            self?.currentTime = time.seconds
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
