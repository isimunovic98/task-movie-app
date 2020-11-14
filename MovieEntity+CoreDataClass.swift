//
//  MovieEntity+CoreDataClass.swift
//  
//
//  Created by Ivan Simunovic on 10/11/2020.
//
//

import UIKit
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {

    class func findByID(_ movieId: Int64) -> MovieEntity? {
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = myAppDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let idPredicate = NSPredicate(format: "id = \(movieId)")
        request.predicate = idPredicate
        
        var result: [AnyObject]?
        var movie: MovieEntity? = nil
        do {
            result = try context.fetch(request)
        } catch let error as NSError {
            NSLog("Error getting movie: \(error)")
            result = nil
        }
        if result != nil {
            for resultItem : AnyObject in result! {
                movie = resultItem as? MovieEntity
            }
        }
        return movie
    }

}
