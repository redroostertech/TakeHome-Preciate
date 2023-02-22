//
//  MovieDetailViewModel.swift
//  TakeHomeProject-Preciate
//
//  Created by Michael Westbrooks II on 2/21/23.
//

import Foundation
import SwiftUI

class MovieDetailViewModel: NSObject, MovieListViewModelProtocol, ObservableObject {

    private let movieId: Int
    let apiService: APIService

    @Published var movie: Movie?

    weak var delegate: MovieListViewControllerViewDelegate?

    init(movieId: Int) {
        self.movieId = movieId
        self.apiService = APIService(endpoint: .movieWithId(movieId))
    }

    func loadData() {
        apiService.fetch { (result: APIResult<Movie>) in
            switch result {
                case .failure(let error):
                    print("Error fetching todos: \(error)")

                case .success(let movie):
                    Task {
                        await self.updateMovie(movie)
                    }
            }
        }
    }

    @MainActor
    func updateMovie(_ movie: Movie) {
        self.movie = movie
        self.delegate?.updateView()
    }
}
