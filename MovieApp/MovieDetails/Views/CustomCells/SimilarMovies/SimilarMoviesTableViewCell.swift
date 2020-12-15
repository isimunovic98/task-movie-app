//
//  SImilarMoviesTableViewCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 15.12.2020..
//

import UIKit

class SimilarMoviesTableViewCell: UITableViewCell {
    //MARK: Properties
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .yellow
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
        contentView.addSubview(collectionView)
        setupConstraints()
        configureCollectionView()
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(150)
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
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let id = viewModel.screenData[indexPath.row].id
    //
    //        let movieDetailsController = MovieDetailsViewController(movieId: id)
    //
    //        navigationController?.pushViewController(movieDetailsController, animated: false)
    //    }
}

//MARK: - CollectionViewDataSource
extension SimilarMoviesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SimilarMovieCollectionViewCell = collectionView.dequeue(for: indexPath)
        
        let title = "TITLE"
        
        cell.configure(with: title)
        
        return cell
    }
}

//MARK: - CollectionViewFlowLayout
extension SimilarMoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,left: 10,bottom: 10,right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: 250)
    }
}
