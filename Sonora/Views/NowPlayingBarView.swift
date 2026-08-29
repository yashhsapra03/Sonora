//
//  NowPlayingBarView.swift
//  Sonora
//
//  Created by Yashh Sapra on 27/08/26.
//

import SwiftUI

struct NowPlayingBarView: View {
    let song: Song
    @Binding var isPlaying: Bool
    var playPauseTap: () -> Void
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: song.artworkUrl100 ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(.rect(cornerRadius: 11))
            
            VStack(alignment: .leading,spacing: 1) {
                Text(song.trackName)
                    .bold()
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button {
                playPauseTap()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 25))
            }
        }
          .padding()
          .background(.ultraThinMaterial)
          .clipShape(.rect(cornerRadius: 20))
          .padding(.horizontal,5)

        
        
        
      
        
    }
}

#Preview {
    @Previewable @State var isPlaying = false
    
    NowPlayingBarView(song: Song(trackId: 1779786209, trackName: "Wavy", artistName: "Karan Aujla", trackTimeMillis: 161000, collectionName: "Wavy - Single", artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/cd/df/5a/cddf5a8c-464e-3958-cf4a-7fac9e490aa5/5063616597178_cover.jpg/100x100bb.jpg", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/6e/d7/12/6ed71252-5ea1-e750-c32f-b022e6847471/mzaf_15658604173507661184.plus.aac.p.m4a"), isPlaying: $isPlaying,playPauseTap: {
        isPlaying.toggle()
    })
}


