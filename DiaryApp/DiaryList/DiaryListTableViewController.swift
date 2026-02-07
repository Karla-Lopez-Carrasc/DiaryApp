//
//  DiaryListTableViewController.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import UIKit

final class DiaryListTableViewController: UITableViewController {

    private let viewModel = DiaryListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Entradas"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
        tableView.reloadData()
    }

    @objc private func addEntry() {
        let editor = EntryEditorViewController()
        navigationController?.pushViewController(editor, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.entries.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let entry = viewModel.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.backgroundColor = entry.isDraft ? .systemYellow.withAlphaComponent(0.2) : .clear
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let entry = viewModel.entries[indexPath.row]
        if entry.isDraft {
            let editor = EntryEditorViewController(entry: entry)
            navigationController?.pushViewController(editor, animated: true)
        } else {
            let detail = EntryDetailViewController(entry: entry)
            navigationController?.pushViewController(detail, animated: true)
        }
    }
}
