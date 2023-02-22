//
//  ViewController.swift
//  TakeHomeProject-Preciate
//
//  Created by Michael Westbrooks II on 2/21/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let keyWindow = UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }

            let movieListViewModel = MovieListViewModel(
                apiService: APIService(endpoint: .movies)
            )
            let movieListViewController = MovieListViewController(
                viewModel: movieListViewModel
            )
            movieListViewModel.delegate = movieListViewController

            let navigationController = UINavigationController(
                rootViewController: movieListViewController
            )
            keyWindow?.rootViewController = navigationController
            keyWindow?.makeKeyAndVisible()
        }
    }
}
