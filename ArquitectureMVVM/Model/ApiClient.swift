//
//  ApliClient.swift
//  ArquitectureMVVM
//
//  Created by Ramiro Gutierrez on 04/04/24.
//

import Foundation

enum BackendError: String, Error {
    case invalidEmail = "Comprueba el email"
    case invalidPassword = "Comprueba la password"
}

final class ApiClient {
    
    func login(withEmail email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
        return try simulateBackendLogin(email: email, password: password)
    }
}

func simulateBackendLogin(email: String, password: String) throws -> User {
    
    guard email == "ramiro.gutierrez03111999@gmail.com" else {
        print("el usuario no es correcto")
        throw BackendError.invalidEmail
    }
    
    guard password == "1234" else {
        print("la contraseña no es correcta")
        throw BackendError.invalidPassword
    }
    print("Success")
    return .init(name: "Ramiro", token: "123456789", sessionStart: .now)
}
