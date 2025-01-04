import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.gray, for: .disabled)
        return button
    }()

    // MARK: - ViewModel
    private let viewModel: HomeViewModel = DefaultHomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        setupUI()
        setupConstraints()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)

        loginButton.isEnabled = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),
            usernameTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            usernameTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.topAnchor.constraint(
                equalTo: usernameTextField.bottomAnchor,
                constant: 10
            ),
            passwordTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            passwordTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            loginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            loginButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        usernameTextField.addTarget(self, action: #selector(didChangeUsername), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePassword), for: .editingChanged)
    }

    // MARK: - Actions

    @objc private func didTapLoginButton() {

    }

    @objc private func didChangeUsername() {
        
    }

    @objc private func didChangePassword() {
    }

}

