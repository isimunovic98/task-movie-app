//
//  Extensions+UIViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03/11/2020.
//

import UIKit

extension UIViewController {
    
    func presentNilURLAlert() {
        let alert = UIAlertController(title: "Error", message: "Url is nil", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    func presentJSONErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Error occured!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    func showBlurLoader() {
        BlurLoaderHelper.addBlurLoader(to: self.view)
    }
    
    func removeBlurLoader() {
        BlurLoaderHelper.removeBlurLoader()
    }
}

