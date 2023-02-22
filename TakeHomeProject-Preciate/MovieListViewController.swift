//
//  MovieListViewController.swift
//  TakeHomeProject-Preciate
//
//  Created by Michael Westbrooks II on 2/21/23.
//

import UIKit

protocol ViewUpdateable {
    func updateView()
}

protocol MovieListViewControllerViewDelegate: AnyObject, ViewUpdateable {
    func presentMovieDetail(movieId: Int) // This should move to a router
}

final class MovieListViewController: UIViewController, MovieListViewControllerViewDelegate {

    // MARK: - Properties

    private let viewModel: MovieListViewModelProtocol & UITableViewDelegate & UITableViewDataSource

    // MARK: - UI Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(viewModel: MovieListViewModelProtocol & UITableViewDelegate & UITableViewDataSource) {
        self.viewModel = viewModel
        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

    // MMARK: - Private member methods

    private func setupUI() {
        self.title = "Movie List"

        configureNavigationBar()
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.estimatedRowHeight = UITableView.automaticDimension
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configureNavigationBar() {
        let newNavBarAppearance = UINavigationBarAppearance()
        newNavBarAppearance.configureWithOpaqueBackground()
        newNavBarAppearance.backgroundColor = .white
        newNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        newNavBarAppearance.buttonAppearance = barButtonItemAppearance
        newNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        newNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        navigationController?.navigationBar.compactAppearance = newNavBarAppearance
        navigationController?.navigationBar.standardAppearance = newNavBarAppearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = newNavBarAppearance
        }
    }

    private func loadData() {
        Task {
            await viewModel.loadData()
        }
    }

    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func presentMovieDetail(movieId: Int) {
        let movieDetailViewModel = MovieDetailViewModel(movieId: movieId)
        self.navigationController?.pushViewController(
            MovieDetailHostingViewController(
                viewModel: movieDetailViewModel
            ),
            animated: true
        )
    }
}

extension MovieListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        movies?.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(
            style: .default,
            reuseIdentifier: "MovieListItemCell"
        )
        guard let movie = movies?[indexPath.row] else {
            return cell
        }
        var config = UIListContentConfiguration.cell()
        config.text = movie.title
        cell.contentConfiguration = config
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if let movie = movies?[indexPath.row] {
            selectMovie(movie: movie)
        }
    }
}
