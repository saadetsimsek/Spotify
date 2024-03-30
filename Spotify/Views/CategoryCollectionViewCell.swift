//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Saadet Şimşek on 28/03/2024.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GenreCollectionViewCell"
    
    private let colors: [UIColor] = [
        .systemRed,
        .systemCyan,
        .systemBlue,
        .systemMint,
        .systemYellow,
        .systemPink,
        .systemGreen,
        .systemOrange,
        .systemPurple,
        .systemIndigo
    ]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        addSubview(label)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10,
                             y: contentView.height/2,
                             width: contentView.width-20,
                             height: contentView.height/2)
        
        imageView.frame = CGRect(x: contentView.width/2,
                                 y: 10,
                                 width: contentView.width/2,
                                 height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50,
                                                                                                                    weight: .regular))
    }
    
    func configure(with viewModels: CategoryCollectionViewCellViewModel) {
        label.text = viewModels.title
        imageView.sd_setImage(with: viewModels.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
