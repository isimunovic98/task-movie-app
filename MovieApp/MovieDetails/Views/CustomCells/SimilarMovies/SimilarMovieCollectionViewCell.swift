//
//  SimilarMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 15.12.2020..
//

import UIKit

class SimilarMovieCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
}

extension SimilarMovieCollectionViewCell {
    func configure(with title: String) {
        titleLabel.text = title
    }
}
