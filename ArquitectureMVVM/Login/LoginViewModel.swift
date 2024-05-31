//
//  LoginViewModel.swift
//  ArquitectureMVVM
//
//  Created by Ramiro Gutierrez on 04/04/24.
//

import Foundation
import Combine



class LoginViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published var isEnabled = false
    
    let apiClient: ApiClient
    var cancellables = Set<AnyCancellable>()
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
        formValidation()
    }
    
    func formValidation() {
        Publishers.CombineLatest($email, $password)
            .filter{email, password in
                return email.count > 5 && password.count > 5
            }
            .sink{value in
                self.isEnabled = true
            }
            .store(in: &cancellables)
//        $email
//            .filter{$0.count > 5}
//            .sink{ value in
//                self.isEnabled = true
//        }.store(in: &cancellables)
//        
//        $password.sink { value in
//            print("password", value)
//        }.store(in: &cancellables)
    }
    @MainActor
    func userLogin(withEmail email: String, password: String) {
        Task {
            do {
              let userModel = try await apiClient.login(withEmail: email, password: password)
            } catch let error as BackendError{
                print(error.localizedDescription)
            }
        }
    }
}
