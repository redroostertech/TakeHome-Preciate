//
//  MovieListViewModel.swift
//  TakeHomeProject-Preciate
//
//  Created by Michael Westbrooks II on 2/21/23.
//

import Foundation

// Would want to abstract movie selection logic away from
// this protocol
protocol MovieListViewModelProtocol {
    // Loading of data should be behind an abstraction
    // that translate the response into a specific
    // model of type decodable
    func loadData() async
    func selectMovie(movie: Movie)
}

extension MovieListViewModelProtocol {
    func selectMovie(movie: Movie) { }
}

struct MovieListApiResponse: Decodable {
    let items: [Movie]
}

class MovieListViewModel: NSObject, MovieListViewModelProtocol {

    let apiService: APIService
    var movies: [Movie]?

    weak var delegate: MovieListViewControllerViewDelegate?

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func loadData() {
        apiService.fetch { (result: APIResult<MovieListApiResponse>) in
            switch result {
                case .failure(let error):
                    print("Error fetching todos: \(error)")

                case .success(let response):
                    self.movies = response.items
                    self.delegate?.updateView()
            }
        }
    }

    func selectMovie(movie: Movie) {
        delegate?.presentMovieDetail(movieId: movie.id)
    }
}
