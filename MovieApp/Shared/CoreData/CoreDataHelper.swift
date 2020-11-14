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
    static func newMovieEntity(_ movie: Movie) -> MovieEntity {
        let newAppMovie = MovieEntity(context: context)
        newAppMovie.id = Int64(movie.id)
        newAppMovie.title = movie.title
        newAppMovie.overview = movie.overview
        newAppMovie.posterPath = movie.poster_path
        newAppMovie.releaseDate = movie.release_date
        
        return newAppMovie
    }
    
    static func newMovieEntity(_ movie: MovieDetails) -> MovieEntity {
        let newAppMovie = MovieEntity(context: context)
        newAppMovie.id = Int64(movie.id)
        newAppMovie.title = movie.title
        newAppMovie.overview = movie.overview
        newAppMovie.posterPath = movie.poster_path
        newAppMovie.releaseDate = movie.release_date
        
        return newAppMovie
    }
    
    //READ
    static func fetchWatchedMovies() -> [MovieEntity] {
        var items: [MovieEntity]
        let fetchRequest = MovieEntity.fetchRequest() as NSFetchRequest<MovieEntity>
        let predicate = NSPredicate(format: "watched = %d", true)
        
        fetchRequest.predicate = predicate
        
        do{
            items = try context.fetch(fetchRequest)
            return items
        }
        catch {
            
        }
        return [MovieEntity]()
    }
    
    static func fetchFavouriteMovies() -> [MovieEntity] {
        var items: [MovieEntity]
        let fetchRequest = MovieEntity.fetchRequest() as NSFetchRequest<MovieEntity>
        let predicate = NSPredicate(format: "favourite = %d", true)
        
        fetchRequest.predicate = predicate
        
        do{
            items = try context.fetch(fetchRequest)
            return items
        }
        catch {
            
        }
        return [MovieEntity]()
    }
    
    //UPDATE
    static func update(_ appMovie: MovieEntity,_ watched: Bool,_ favourite: Bool ){
        appMovie.setValue(watched, forKey: "watched")
        appMovie.setValue(favourite, forKey: "favourite")
        
        do { try context.save() }
        catch {
            fatalError("Error saving movie")
        }
    }
    
    static func updateWatched(withId id: Int64,_ watched: Bool) {
        let appMovie = MovieEntity.findByID(Int64(id))
        appMovie?.setValue(watched, forKey: "watched")
        
        do { try context.save() }
        catch {
            fatalError("Error saving movie")
        }
    }
    
    static func updateFavourite(withId id: Int64,_ favourite: Bool) {
        let appMovie = MovieEntity.findByID(Int64(id))
        appMovie?.setValue(favourite, forKey: "favourite")
        
        do { try self.context.save() }
        catch {
            fatalError("Error saving movie")
        }
    }
    
    //DELETE
    static func deleteAllData() {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieAppMovie")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do {
            try context.execute(DelAllReqVar)
            
        }
        catch { print(error) }
    }
    
    //Methods
    static func saveOrUpdate(_ movie: Movie,_ watched: Bool,_ favourite: Bool) {
        if let appMovie = MovieEntity.findByID(Int64(movie.id)) {
                update(appMovie, watched, favourite)
            do {
                try context.save()
            }
            catch {
                fatalError("Error saving movie")
            }
        } else {
            save(movie, watched, favourite)
        }
    }
    
    static func save(_ movie: Movie,_ watched: Bool,_ favourite: Bool) {
        let newAppMovie = newMovieEntity(movie)
        newAppMovie.watched = watched
        newAppMovie.favourite = favourite
        do {
            try self.context.save()
        }
        catch {
            fatalError("Error saving movie")
        }
    }
    
    static func saveOrUpdate(_ movie: MovieDetails,_ watched: Bool,_ favourite: Bool) {
        if let appMovie = MovieEntity.findByID(Int64(movie.id)) {
                update(appMovie, watched, favourite)
            do {
                try context.save()
            }
            catch {
                fatalError("Error saving movie")
            }
        } else {
            save(movie, watched, favourite)
        }
    }
    
    static func save(_ movie: MovieDetails,_ watched: Bool,_ favourite: Bool) {
        let newAppMovie = newMovieEntity(movie)
        newAppMovie.watched = watched
        newAppMovie.favourite = favourite
        do {
            try self.context.save()
        }
        catch {
            fatalError("Error saving movie")
        }
    }

}
