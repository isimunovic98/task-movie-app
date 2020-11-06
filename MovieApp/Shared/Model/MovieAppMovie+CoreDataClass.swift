//
//  MovieAppMovie+CoreDataClass.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05/11/2020.
//
//

import UIKit
import CoreData

@objc(MovieAppMovie)
public class MovieAppMovie: NSManagedObject {
    
    class func findByID(_ movieId: Int64) -> MovieAppMovie? {
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = myAppDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieAppMovie")
        let idPredicate = NSPredicate(format: "id = \(movieId)", argumentArray: nil)
        request.predicate = idPredicate
        
        var result: [AnyObject]?
        var movie: MovieAppMovie? = nil
        do {
            result = try context.fetch(request)
        } catch let error as NSError {
            NSLog("Error getting movie: \(error)")
            result = nil
        }
        if result != nil {
            for resultItem : AnyObject in result! {
                movie = resultItem as? MovieAppMovie
            }
        }
        return movie
    }
    
}
