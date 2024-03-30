//
//  SearchResult.swift
//  Spotify
//
//  Created by Saadet Şimşek on 30/03/2024.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
