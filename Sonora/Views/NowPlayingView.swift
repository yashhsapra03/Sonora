//
//  NowPlayingView.swift
//  Sonora
//
//  Created by Yashh Sapra on 30/08/26.
//

import SwiftUI

struct NowPlayingView: View {
    let song: Song
    @Binding var isPlaying: Bool
    @Environment(\.dismiss) var dismiss
    var playPauseTap: () -> Void
    var body: some View {
        VStack {
            
            Button{
                dismiss()
            } label: {
                Image(systemName: "chevron.down")
            }
            .padding(.top,20)
            .padding(.bottom,20)
            
          
            AsyncImage(url: URL(string: song.artworkUrl100?.replacingOccurrences(of: "100x100bb", with: "1200x1200bb") ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 340, height: 350)
            .clipShape(.rect(cornerRadius: 20))
            
            HStack{
                VStack(alignment: .center) {
                    Text(song.trackName).font(.title).bold()
                    Text(song.artistName).foregroundStyle(.secondary)
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
            }

            Spacer()
            // Progress Bar
            HStack {
                Text("//Slider")
            }
            .font(.title)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .background(.red)
            .padding(.bottom,40)
            
            HStack(spacing: 40){
                Button {
                    
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.blue)
                }
                Button{
                    playPauseTap()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 30))
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue.opacity(0.8))
                        .clipShape(.circle)
                }
                
                Button {

                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.blue)
                }
                
            }
            .padding()
            .background(.ultraThinMaterial)
            .padding(.bottom,70)
        }

    }
    
}

#Preview {
    
    @Previewable @State var isPlaying = false
    NowPlayingView(song: Song(trackId: 1779786209, trackName: "Wavy", artistName: "Karan Aujla", trackTimeMillis: 161000, collectionName: "Wavy - Single", artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/cd/df/5a/cddf5a8c-464e-3958-cf4a-7fac9e490aa5/5063616597178_cover.jpg/100x100bb.jpg", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/6e/d7/12/6ed71252-5ea1-e750-c32f-b022e6847471/mzaf_15658604173507661184.plus.aac.p.m4a"), isPlaying: $isPlaying,playPauseTap: { isPlaying.toggle()})
    
}
