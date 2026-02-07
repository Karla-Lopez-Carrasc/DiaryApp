//
//  SceneDelegate.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static var isLocked = true

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = AuthenticationViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    /// Se llama cuando la app pasa a background o se interrumpe
    func sceneWillResignActive(_ scene: UIScene) {
        SceneDelegate.isLocked = true
    }

    /// Se llama cuando la app vuelve a estar activa
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard SceneDelegate.isLocked else { return }
        window?.rootViewController = AuthenticationViewController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // No necesitamos lógica aquí por ahora
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Opcional: podrías guardar estado aquí si quisieras
    }
}

