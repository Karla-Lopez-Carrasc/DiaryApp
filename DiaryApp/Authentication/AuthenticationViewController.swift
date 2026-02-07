//
//  AuthenticationViewController.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import UIKit

final class AuthenticationViewController: UIViewController {

    private let viewModel = AuthenticationViewModel()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mi Diario"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Autenticar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        button.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
    }

    private func setupUI() {
        [titleLabel, button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])
    }

    @objc private func authenticate() {
        viewModel.authenticate { [weak self] success in
            guard success else { return }
            SceneDelegate.isLocked = false
            let listVC = DiaryListTableViewController()
            let nav = UINavigationController(rootViewController: listVC)
            self?.view.window?.rootViewController = nav
        }
    }
}
