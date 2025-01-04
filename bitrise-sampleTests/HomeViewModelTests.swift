@testable import bitrise_sample
import XCTest

final class HomeViewModelTests: XCTestCase {
    var sut: DefaultHomeViewModel!

    override func setUpWithError() throws {
        sut = DefaultHomeViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_updateUserName_shouldUpdateUserNameValue() throws {

    }

    func test_updatePassword_shouuldUpdatePasswordValue() {
        
    }
}
