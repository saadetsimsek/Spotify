//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Saadet Şimşek on 11/03/2024.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist
    
    public var isOWner = false
    
    private var viewModels = [RecommendedTrackCellViewModels]()
    
    private var tracks = [AudioTrack]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ ->
        NSCollectionLayoutSection? in
        //Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        // Vertical group in horizontal group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)),
            subitem: item,
            count: 1)
      
        
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                           heightDimension: .fractionalWidth(1)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]
        return section
    }))
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        APICaller.shared.getPlaylistDetails(for: playlist) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    //recommendedTrackCellViewModel
                    self?.tracks = model.tracks.items.compactMap({$0.track})
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModels(name: $0.track.name,
                                                       artistName: $0.track.artists.first?.name ?? "-",
                                                       artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    break
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        let gesture = UIGestureRecognizer(target: self,
                                          action: #selector(didLongPress))
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        let touchPonint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPonint) else{
            return
        }
        let trackToDelete = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: trackToDelete.name,
                                            message: "Would you like to remove this from the playlist?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove",
                                            style: .destructive,
                                            handler: {[weak self] _ in
            guard let strongSelf = self else{
                return
            }
            APICaller.shared.removeTrackFromPlaylist(track: trackToDelete,
                                                     playlist: strongSelf.playlist) { success in
                if success {
                    print("Remove")
                    DispatchQueue.main.async {
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModels.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                    }
                }
                else{
                    print("Failed to remove")
                }
            }
        }))
    }
    
    @objc public func didTapShare(){
     //   print((playlist.external_urls))
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else{
            return
        }
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
              for: indexPath
          ) as? PlaylistHeaderCollectionReusableView,
          kind == UICollectionView.elementKindSectionHeader else {
              return UICollectionReusableView()
          }
        //header, configure( with: headerViewModel
          let headerViewModel = PlaylistHeaderViewViewModel(
              name: playlist.name,
              ownerName: playlist.owner.display_name,
              description: playlist.description,
              artworkURL: URL(string: playlist.images.first?.url ?? "")
          )
          header.configure(with: headerViewModel)
          header.delegate = self
          return header
        
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //Play song
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
        
    }
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //start play list play in queue
       // print("Playing all")
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
    
    
}
