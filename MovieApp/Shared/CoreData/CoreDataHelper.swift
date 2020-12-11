//
//  CoreDataHelper.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05/11/2020.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }

        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext

        return context
    }()
    
    //CREATE
    static func newMovieEntity(_ movie: MovieRepresentable) -> MovieEntity {
        let newMovieEntity = MovieEntity(context: context)
        newMovieEntity.id = Int64(movie.id)
        newMovieEntity.title = movie.title
        newMovieEntity.overview = movie.overview
        newMovieEntity.posterPath = movie.posterPath
        newMovieEntity.releaseDate = movie.releaseDate
    
        return newMovieEntity
    }
    
    //READ
    static func fetchWatchedMovies() -> [MovieRepresentable] {
        var entityes: [MovieEntity]
        let fetchRequest = MovieEntity.fetchRequest() as NSFetchRequest<MovieEntity>
        let predicate = NSPredicate(format: "watched = %d", true)
        
        fetchRequest.predicate = predicate
        
        do{
            entityes = try context.fetch(fetchRequest)
            let moviesTemp = entityes.map { (movie) -> MovieRepresentable in
                return MovieRepresentable(movie)
            }
            return moviesTemp
        }
        catch {
            
        }
        return [MovieRepresentable]()
    }
    
    static func fetchFavouritedMovies() -> [MovieRepresentable] {
        var entityes: [MovieEntity]
        let fetchRequest = MovieEntity.fetchRequest() as NSFetchRequest<MovieEntity>
        let predicate = NSPredicate(format: "favourite = %d", true)
        
        fetchRequest.predicate = predicate
        
        do{
            entityes = try context.fetch(fetchRequest)
            let moviesTemp = entityes.map({
                MovieRepresentable($0)
            })
            return moviesTemp
        }
        catch {
            
        }
        return [MovieRepresentable]()
    }
    
    //UPDATE
    static func update(_ movieEntity: MovieEntity,_ watched: Bool,_ favourite: Bool ){
        movieEntity.setValue(watched, forKey: "watched")
        movieEntity.setValue(favourite, forKey: "favourite")
        
        do { try context.save() }
        catch {
            fatalError("Error saving movie")
        }
    }
    
    static func updateWatched(withId id: Int,_ watched: Bool) {
        let appMovie = MovieEntity.findByID(id)
        appMovie?.setValue(watched, forKey: "watched")
        
        do { try context.save() }
        catch {
            fatalError("Error saving movie")
        }
    }
    
    static func updateFavourited(withId id: Int,_ favourite: Bool) {
        let appMovie = MovieEntity.findByID(id)
        appMovie?.setValue(favourite, forKey: "favourite")
        
        do { try self.context.save() }
        catch {
            fatalError("Error saving movie")
        }
    }
    
    //DELETE
    static func deleteAllData() {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do {
            try context.execute(DelAllReqVar)
            
        }
        catch { print(error) }
    }
    
    //Methods
    

    static func saveOrUpdate(_ movie: MovieRepresentable) {
        if let movieEntity = MovieEntity.findByID(movie.id) {
            update(movieEntity, movie.watched, movie.favourited)
            do {
                try context.save()
            }
            catch {
                fatalError("Error saving movie")
            }
        } else {
            save(movie, movie.watched, movie.favourited)
        }
    }
    
    static func save(_ movie: MovieRepresentable,_ watched: Bool,_ favourite: Bool) {
        let movieEntity = newMovieEntity(movie)
        movieEntity.watched = watched
        movieEntity.favourite = favourite
        do {
            try self.context.save()
        }
        catch {
            fatalError("Error saving movie")
        }
    }
}
