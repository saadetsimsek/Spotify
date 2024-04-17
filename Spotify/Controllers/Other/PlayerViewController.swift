//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Saadet Şimşek on 11/03/2024.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0,
                                 y: view.safeAreaInsets.top,
                                 width: view.width,
                                 height: view.width)
        
        controlsView.frame = CGRect(x: 10,
                                    y: imageView.bottom+10,
                                    width: view.width-20,
                                    height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-10)
    }
    
    private func configureBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapAction))

    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction(){
        // Actions
        
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    
}
