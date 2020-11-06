//
//  MovieAppMovie+CoreDataProperties.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05/11/2020.
//
//

import Foundation
import CoreData


extension MovieAppMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieAppMovie> {
        return NSFetchRequest<MovieAppMovie>(entityName: "MovieAppMovie")
    }

    @NSManaged public var favourite: Bool
    @NSManaged public var id: Int64
    @NSManaged public var watched: Bool
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?

}

extension MovieAppMovie : Identifiable {

}
