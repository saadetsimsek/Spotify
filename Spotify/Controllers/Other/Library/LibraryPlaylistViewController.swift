//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by Saadet Şimşek on 22/04/2024.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
 
 var playlists = [Playlist]()
 
 public var selectionHandler: ((Playlist) -> Void)?
 
 private let noPlaylistView = ActionLabelView()
 
 private let tableView: UITableView = {
     let tableView = UITableView(frame: .zero, style: .grouped)
     tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
     tableView.isHidden = true
     return tableView
 }()
 
 override func viewDidLoad() {
     super.viewDidLoad()
     view.backgroundColor = .systemBackground
     tableView.delegate = self
     tableView.dataSource = self
     view.addSubview(tableView)
     setUpNoPlaylistsView()
     fetchData()
     
     if selectionHandler != nil {
         navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .close,
                                                             target: self,
                                                             action: #selector(didTapClose))
     }
 }
 
 @objc func didTapClose(){
     dismiss(animated: true)
 }
 
 override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     noPlaylistView.frame = CGRect(x: 0,
                                   y: 0,
                                   width: 150,
                                   height: 150)
     noPlaylistView.center = view.center
     
     tableView.frame = view.bounds
 }
 
 private func setUpNoPlaylistsView(){
     view.addSubview(noPlaylistView)
     noPlaylistView.delegate = self
     noPlaylistView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlist yet.",
                                                             actionTitle: "Create"))
 }
 
 private func fetchData(){
     APICaller.shared.getCurrentUserPlaylists {[weak self] result in
         DispatchQueue.main.async {
             switch result {
             case .success(let playlists):
                 self?.playlists = playlists
                 self?.updateUI()
             case .failure(let error):
                 print(error.localizedDescription)
             }
         }
     }
 }
 
 private func updateUI() {
       if playlists.isEmpty {
           // Show label
           noPlaylistView.isHidden = false
           tableView.isHidden = true
       }
       else {
           // Show table
           tableView.reloadData()
           noPlaylistView.isHidden = true
           tableView.isHidden = false
       }
   }
 
 public func showCreatePlaylistAlert(){
     let alert = UIAlertController(title: "New Playlist name",
                                   message: "Enter playlist name",
                                   preferredStyle: .alert)
     alert.addTextField { textfield in
         textfield.placeholder = "Playlist..."
     }
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
     alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
         guard let field = alert.textFields?.first,
               let text = field.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty else{
             return
         }
         APICaller.shared.createPlaylist(with: text) { success in
             if success{
                 HapticsManager.shared.vibrate(for: .success)
                 //Refresh list of playlists
                 self.fetchData()
             }
             else{
                 HapticsManager.shared.vibrate(for: .error)
                 print("Failed to create playlist")
             }
         }
     }))
     
     present(alert, animated: true)
 }
}

extension LibraryPlaylistViewController: ActionLabelViewDelegate {
 func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
     //show creation UI
     showCreatePlaylistAlert()
     
 }
}

extension LibraryPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: playlist.name,
                                                                        subtitle: playlist.owner.display_name,
                                                                        imageURL: URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else{
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlaylistViewController(playlist:  playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOWner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
