#if os(Linux)

import XCTest
@testable import AirmailTests

XCTMain([

    // ConsoleMailClientTests
    testCase(ConsoleMailClientTests.allTests),

    // InMemoryMailClientTests
    testCase(InMemoryMailClientTests.allTests),

    // SendGrid Tests
    testCase(SendGridTests.allTests),

])

#endif
