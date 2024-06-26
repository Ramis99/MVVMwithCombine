//
//  ViewController.swift
//  ArquitectureMVVM
//
//  Created by Ramiro Gutierrez on 04/04/24.
//

import UIKit
import Combine

class LoginView: UIViewController {
    private let viewModel = LoginViewModel(apiClient: ApiClient())
    var cancellables = Set<AnyCancellable>()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Agrega tu email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Agrega tu password"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.subtitle  = "Pagina chida"
        configuration.image = UIImage(systemName: "play.circle.fill")
        configuration.imagePadding = 8
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { action in
            self.startLogin()
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createBindingViewWithViewModel()
        [emailTextField, passwordTextField, loginButton].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func startLogin() {
        viewModel.userLogin(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    func createBindingViewWithViewModel() {
        emailTextField.textPublisher.assign(to: \LoginViewModel.email, on: viewModel).store(in: &cancellables)
        passwordTextField.textPublisher.assign(to: \LoginViewModel.password, on: viewModel).store(in: &cancellables)
        viewModel.$isEnabled.assign(to: \.isEnabled, on: loginButton).store(in: &cancellables)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        return NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { notification in
                return (notification.object as? UITextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}

