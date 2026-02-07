//
//  AuthenticationViewModel.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import LocalAuthentication

final class AuthenticationViewModel {

    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false)
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Protege tus entradas personales"
        ) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}

