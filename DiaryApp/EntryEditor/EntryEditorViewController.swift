//
//  EntryEditorViewController.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import UIKit
import PhotosUI

final class EntryEditorViewController: UIViewController {

    private let viewModel: EntryEditorViewModel

    // MARK: UI
    private let titleField = UITextField()
    private let messageTextView = UITextView()
    private let imageView = UIImageView()
    private let locationLabel = UILabel()
    private let photoButton = UIButton(type: .system)
    private let locationButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)

    // MARK: Init
    init(entry: DiaryEntry? = nil) {
        self.viewModel = EntryEditorViewModel(entry: entry)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editor"
        view.backgroundColor = .systemBackground
        setupUI()
        fillIfNeeded()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveDraft),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    private func fillIfNeeded() {
        let entry = viewModel.entry
        titleField.text = entry.title
        messageTextView.text = entry.message
        locationLabel.text = entry.latitude != nil ? "Ubicación seleccionada" : "Sin ubicación"
    }

    private func setupUI() {
        titleField.placeholder = "Título"
        titleField.borderStyle = .roundedRect

        messageTextView.layer.borderWidth = 1
        messageTextView.layer.cornerRadius = 8
        messageTextView.layer.borderColor = UIColor.systemGray4.cgColor

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        locationLabel.textColor = .secondaryLabel
        locationLabel.textAlignment = .center

        photoButton.setTitle("Añadir foto", for: .normal)
        locationButton.setTitle("Añadir ubicación", for: .normal)
        saveButton.setTitle("Guardar", for: .normal)

        photoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveFinal), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            titleField,
            messageTextView,
            photoButton,
            imageView,
            locationButton,
            locationLabel,
            saveButton
        ])

        stack.axis = .vertical
        stack.spacing = 16

        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: Actions
    @objc private func saveFinal() {
        viewModel.updateTitle(titleField.text ?? "")
        viewModel.updateMessage(messageTextView.text)
        viewModel.save(isDraft: false)
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveDraft() {
        viewModel.updateTitle(titleField.text ?? "")
        viewModel.updateMessage(messageTextView.text)
        viewModel.save(isDraft: true)
    }
}


extension EntryEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc private func addPhoto() {
        let alert = UIAlertController(title: "Foto", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Tomar foto", style: .default) { _ in
                self.presentPicker(.camera)
            })
        }

        alert.addAction(UIAlertAction(title: "Elegir de galería", style: .default) { _ in
            self.presentGallery()
        })

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    private func presentPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        present(picker, animated: true)
    }

    private func presentGallery() {
        var config = PHPickerConfiguration()
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension EntryEditorViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { image, _ in
            guard let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
                self.viewModel.setImage(image)
            }
        }
    }
}

// MARK: - Location
extension EntryEditorViewController: LocationSearchDelegate {

    @objc func addLocation() {
        let locationVC = LocationSearchViewController()
        locationVC.delegate = self

        let nav = UINavigationController(rootViewController: locationVC)
        present(nav, animated: true)
    }

    func didSelectLocation(_ location: Location) {
        viewModel.setLocation(location)
        locationLabel.text = location.address ?? "Ubicación seleccionada"
    }
}
