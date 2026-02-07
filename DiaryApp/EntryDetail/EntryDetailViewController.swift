//
//  EntryDetailViewController.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import UIKit
import MapKit
import CoreLocation
import Lottie

final class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: EntryDetailViewModel

    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?

    private let mapView = MKMapView()

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let messageLabel = UILabel()
    private let imageView = UIImageView()

    private let segmented = UISegmentedControl(items: ["Caminar", "Conducir"])
    private let directionsButton = UIButton(type: .system)

    private let animationView = LottieAnimationView(name: "jumping_pokeball")

    // MARK: - Init
    init(entry: DiaryEntry) {
        self.viewModel = EntryDetailViewModel(entry: entry)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Detalle"

        // Map & Location
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        setupUI()
        configureData()
        setupMapIfNeeded()
        setupAnimation()
    }

    // MARK: - UI
    private func setupUI() {

        titleLabel.font = .boldSystemFont(ofSize: 24)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel

        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.heightAnchor.constraint(equalToConstant: 180).isActive = true

        mapView.heightAnchor.constraint(equalToConstant: 260).isActive = true

        segmented.selectedSegmentIndex = 0

        directionsButton.setTitle("Obtener direcciones", for: .normal)
        directionsButton.addTarget(self, action: #selector(openDirections), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            dateLabel,
            messageLabel,
            imageView,
            animationView,
            segmented,
            directionsButton,
            mapView
        ])

        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Data
    private func configureData() {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.dateText
        messageLabel.text = viewModel.message

        if let imagePath = viewModel.entry.imagePath,
           let documents = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
           ).first {
            let url = documents.appendingPathComponent(imagePath)
            imageView.image = UIImage(contentsOfFile: url.path)
        } else {
            imageView.isHidden = true
        }
    }

    // MARK: - Map setup
    private func setupMapIfNeeded() {
        guard let coordinate = viewModel.coordinate else {
            mapView.isHidden = true
            segmented.isHidden = true
            directionsButton.isHidden = true
            return
        }

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: false
        )
    }

    // MARK: - Lottie
    private func setupAnimation() {
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        animationView.play()
    }

    // MARK: - Directions
    @objc private func openDirections() {

        guard
            let userLocation = userLocation,
            let destination = viewModel.coordinate
        else {
            print("Ubicación del usuario aún no disponible")
            return
        }

        mapView.removeOverlays(mapView.overlays)

        let request = MKDirections.Request()
        request.source = MKMapItem(
            placemark: MKPlacemark(coordinate: userLocation.coordinate)
        )
        request.destination = MKMapItem(
            placemark: MKPlacemark(coordinate: destination)
        )

        request.transportType =
            segmented.selectedSegmentIndex == 0
            ? .walking
            : .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let route = response?.routes.first else {
                print("No se pudo calcular la ruta")
                return
            }

            self?.mapView.addOverlay(route.polyline)
            self?.mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
                animated: true
            )
        }
    }
}

// MARK: - Map Renderer
extension EntryDetailViewController: MKMapViewDelegate {

    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}

// MARK: - Location Manager
extension EntryDetailViewController: CLLocationManagerDelegate {

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        userLocation = locations.last
    }
}
