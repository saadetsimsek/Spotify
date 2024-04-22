//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Saadet Şimşek on 22/04/2024.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToogleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist  //ilk playlist seçili
    
    weak var delegate: LibraryToggleViewDelegate?
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(playlistButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylists),
                                 for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlaylists(){
        state = .playlist
        UIView.animate(withDuration: 0.2) { //indicator animate
            self.layoutIndicator()
        }
        delegate?.libraryToogleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums(){
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapAlbums(_toggleView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistButton.frame = CGRect(x: 0,
                                      y: 0,
                                      width: 100,
                                      height: 40)
        albumsButton.frame = CGRect(x: playlistButton.right,
                                    y: 0,
                                    width: 100,
                                    height: 40)
        layoutIndicator()
     
    }
    
    private func layoutIndicator(){
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0,
                                         y: playlistButton.bottom,
                                         width: 100,
                                         height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 100,
                                         y: playlistButton.bottom,
                                         width: 100,
                                         height: 3)
        }
    }
    
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
