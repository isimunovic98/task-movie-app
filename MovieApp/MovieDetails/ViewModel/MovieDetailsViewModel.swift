//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 06.12.2020..
//

import Foundation
import Combine

class MovieDetailsViewModel {
    var id: Int
    var movieRepresentable: MovieRepresentable!
    var screenData: [RowItem] = []
    
    let shouldShowBlurLoaderSubject = PassthroughSubject<Bool, Never>()
    let screenDataReadySubject = PassthroughSubject<Void, Never>()
    let dataLoaderSubject = PassthroughSubject<Bool, Never>()
    let actionButtonTappedSubject = PassthroughSubject<ActionButton, Never>()
    
    init(movieId: Int) {
        self.id = movieId
    }
    
    func fetchItems(dataLoader: PassthroughSubject<Bool, Never>) -> AnyCancellable {
        return dataLoader
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] value -> AnyPublisher<[RowItem], Error> in
                self.shouldShowBlurLoaderSubject.send(true)
                
                let similarMovies = APIService.fetchItems(from: Constants.similarMovies(of: id), as: SimilarMovies.self)
                    .map({
                        $0.similarMovies
                    })
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
                
                let movieDetails = APIService.fetchItems(from: Constants.movieDetails(of: id), as: MovieDetails.self)
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
                
                var screenDataPublisher: AnyPublisher<[RowItem], Error> {
                    return Publishers.CombineLatest(movieDetails, similarMovies)
                        .map({ details, similars in
                            self.createScreenData(from: details, and: similars)
                        })
                        .eraseToAnyPublisher()
                }
                return screenDataPublisher
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                }
            }, receiveValue: { [unowned self] screenData in
                self.screenData = screenData
                self.screenDataReadySubject.send()
                self.shouldShowBlurLoaderSubject.send(false)
            })
    }
    
    func attachButtonClickListener(listener: PassthroughSubject<ActionButton, Never>) -> AnyCancellable {
        return listener
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map({ [unowned self] button in
                self.updateStatus(in: screenData, onTapped: button)
            })
            .sink(receiveValue: { [unowned self] _ in
                self.screenDataReadySubject.send()
            })
    }
    
    
}

extension MovieDetailsViewModel {
    //MARK: Data Creation
    private func createScreenData(from movieDetails: MovieDetails, and similarMovies: [SimilarMovie]) -> [RowItem] {
        movieRepresentable = MovieRepresentable(movieDetails)
        var rowItems = [RowItem]()
        rowItems.append(createInfoItem(for: id, with: movieDetails.posterPath))
        rowItems.append(RowItem(content: movieDetails.title , type: .title))
        rowItems.append(RowItem(content: movieDetails.genres, type: .genres))
        rowItems.append(RowItem(content: movieDetails.tagline, type: .quote))
        rowItems.append(RowItem(content: movieDetails.overview , type: .overview))
        rowItems.append(RowItem(content: similarMovies, type: .similarMovies))
        return rowItems
    }
    
    private func createInfoItem(for id: Int, with posterPath: String) -> RowItem {
        let dbMovie = MovieEntity.findByID(id)
        return RowItem(content: InfoItem(posterPath: posterPath, watched: dbMovie?.watched ?? false, favourited: dbMovie?.favourite ?? false) , type: .poster)
        
    }

    //MARK: Button Clicks
    func updateStatus(in movies: [RowItem], onTapped button: ActionButton) {
        
        if MovieEntity.findByID(id) == nil {
            CoreDataHelper.save(movieRepresentable, false, false)
        }
        
        switch button.type {
        case .watched:
            CoreDataHelper.updateWatched(withId: id)
            switchState(in: screenData, on: .watched)
        case .favourited:
            CoreDataHelper.updateFavourited(withId: id)
            switchState(in: screenData, on: .favourited)
        }
    }
    
    private func switchState(in screenData: [RowItem], on type: ActionButtonType) {
        for (index, cell) in screenData.enumerated() {
            if cell.type == .poster {
                if var item = cell.content as? InfoItem {
                    switch type {
                    case .watched:
                        item.switchWatched()
                    case .favourited:
                        item.switchFavourited()
                    }
                    self.screenData[index].content = item
                }
            }
        }
    }
    
}
