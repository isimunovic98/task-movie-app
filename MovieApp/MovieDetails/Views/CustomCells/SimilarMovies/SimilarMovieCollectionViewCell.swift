//
//  SimilarMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 15.12.2020..
//

import UIKit

class SimilarMovieCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = label.font.withSize(14)
        label.textColor = .white
        return label
    }()
    
    let gradient: ShaderTopToBottom = {
        let shader = ShaderTopToBottom()
        shader.translatesAutoresizingMaskIntoConstraints = false
        return shader
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SimilarMovieCollectionViewCell {
    
    func setupUI() {
        backgroundColor = .white
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(gradient)
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        posterImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        gradient.snp.makeConstraints { (make) in
            make.edges.equalTo(posterImageView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(posterImageView)
        }
    }
}

extension SimilarMovieCollectionViewCell {
    func configure(with similarMovie: SimilarMovie) {
        posterImageView.setImageFromUrl(Constants.poster(path: similarMovie.posterPath))
        titleLabel.text = similarMovie.title
    }
}
