//
//  LocationSearchDelegate.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import UIKit

protocol LocationSearchDelegate: AnyObject {
    func didSelectLocation(_ location: Location)
}

final class LocationSearchViewController: UIViewController {

    weak var delegate: LocationSearchDelegate?
    private let viewModel = LocationSearchViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar ubicación"
        view.backgroundColor = .systemBackground

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        let stack = UIStackView(arrangedSubviews: [searchBar, tableView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateQuery(searchText)
    }
}

extension LocationSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let result = viewModel.results[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = viewModel.results[indexPath.row]
        viewModel.resolve(completion: result) { location in
            self.delegate?.didSelectLocation(location)
            self.dismiss(animated: true)
        }
    }
}
