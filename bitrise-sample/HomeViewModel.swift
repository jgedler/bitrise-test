import Foundation

protocol HomeViewModel {
    func updateUsername(_ username: String)
    func updatePassword(_ password: String)
    var isLoginButtonEnabled: Bool { get }
    func login()
}

final class DefaultHomeViewModel: HomeViewModel {
    // MARK: - Properties
    private(set) var username: String = ""
    private(set) var password: String = ""

    // MARK: - HomeViewModel
    func updateUsername(_ username: String) {
        self.username = username
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    var isLoginButtonEnabled: Bool {
        !(username.isEmpty && password.isEmpty)
    }

    func login() {
        print("perform login")
    }
}

