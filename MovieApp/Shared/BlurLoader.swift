//
//  BlurLoader.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03/11/2020.
//

import UIKit

class BlurLoader: UIView {

    var blurEffectView: UIVisualEffectView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        addSubview(blurEffectView)
    }
    
    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
    }

}
