//
//  NowPlayingListLayout.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 15.11.2020..
//

import UIKit

protocol NowPlayingListLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexpath: IndexPath) -> CGFloat
}

class NowPlayingListLayout: UICollectionViewFlowLayout {

    weak var delegate: NowPlayingListLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPaddinf: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
}
