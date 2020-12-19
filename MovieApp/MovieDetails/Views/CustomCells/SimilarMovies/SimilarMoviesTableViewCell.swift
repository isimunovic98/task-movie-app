//
//  SImilarMoviesTableViewCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 15.12.2020..
//

import UIKit

class SimilarMoviesTableViewCell: UITableViewCell {
    //MARK: Properties
    var similarMovies = [SimilarMovie]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = UIColor(named: "cellColor")
        return collectionView
    }()
    
    //MARK: Init
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SimilarMoviesTableViewCell {
    
    func setupUI() {
        contentView.backgroundColor = UIColor(named: "cellColor")
        contentView.addSubview(collectionView)
        setupConstraints()
        configureCollectionView()
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(180)
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SimilarMovieCollectionViewCell.self, forCellWithReuseIdentifier: SimilarMovieCollectionViewCell.reuseIdentifier)
    }
}

//MARK: - CollectionViewDelegate
extension SimilarMoviesTableViewCell: UICollectionViewDelegate {
    //TO-DO on item press
}

//MARK: - CollectionViewDataSource
extension SimilarMoviesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SimilarMovieCollectionViewCell = collectionView.dequeue(for: indexPath)
        
        let similarMovie = similarMovies[indexPath.row]
        
        cell.configure(with: similarMovie)
        
        return cell
    }
}

//MARK: - CollectionViewFlowLayout
extension SimilarMoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = contentView.frame.size.width - 20
        let collectionViewHeight = contentView.frame.size.height - 35
        
        return CGSize(width: collectionViewWidth/2.5, height: collectionViewHeight)
    }
}
