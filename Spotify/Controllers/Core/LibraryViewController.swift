//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Saadet Şimşek on 11/03/2024.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private let playlistsVC = LibraryPlaylistViewController()
    private let allbumsVC = LibraryAlbumsViewController()
    
    private let toogleView = LibraryToggleView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(toogleView)
        toogleView.delegate = self
       
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.width*2,
                                        height: scrollView.height)
        scrollView.delegate = self
        addChildren()
        updateBarButtons()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top+55,
                                  width: view.width,
                                  height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55)
        toogleView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top,
                                  width: 200,
                                  height: 55)
    }
    
    private func updateBarButtons(){
        switch toogleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAdd(){
        playlistsVC.showCreatePlaylistAlert()
    }
    
    private func addChildren(){
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0,
                                        y: 0, 
                                        width: scrollView.width,
                                        height: scrollView.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(allbumsVC)
        scrollView.addSubview(allbumsVC.view)
        allbumsVC.view.frame = CGRect(x: view.width,
                                        y: 0,
                                        width: scrollView.width,
                                        height: scrollView.height)
        allbumsVC.didMove(toParent: self)
        
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-100) {
            toogleView.update(for: .album)
            updateBarButtons()
        }
        else{
            toogleView.update(for: .playlist)
            updateBarButtons()
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    func libraryToogleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbums(_toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
    
    
}
