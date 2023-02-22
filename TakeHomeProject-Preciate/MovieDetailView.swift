//
//  MovieDetailViewController.swift
//  TakeHomeProject-Preciate
//
//  Created by Michael Westbrooks II on 2/21/23.
//

import UIKit
import SwiftUI

final class MovieDetailHostingViewController: UIHostingController<MovieDetailView> {

    init(viewModel: MovieDetailViewModel) {
        super.init(rootView: MovieDetailView(
            viewModel: viewModel
        ))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        viewModel.loadData()
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 16.0
        ) {
            if let movie = viewModel.movie {
                HStack(
                    alignment: .center,
                    spacing: 16.0
                ) {
                    Text(movie.title)
                        .font(.largeTitle)
                    if let year = movie.year {
                        Text(year)
                            .font(.caption)
                    }
                    Spacer()
                }
                Spacer()
            } else {
                Text("No data available")
            }
        }
        .padding()
    }
}
