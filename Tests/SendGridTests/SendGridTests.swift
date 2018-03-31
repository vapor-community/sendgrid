import XCTest
@testable import SendGrid
@testable import Vapor
// Test inbox: https://www.mailinator.com/inbox2.jsp?public_to=vapor-sendgrid

class SendGridTests: XCTestCase {
    
    /**
     Only way we can test if our request is valid is to use an actual APi key.
     Maybe we'll use the testwithvapor@gmail account for these tests if it becomes
     a recurring theme we need api keys to test providers.
     */
    
    func testNothing() {
        XCTAssertTrue(true)
    }
}
