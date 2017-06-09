#if os(Linux)

import XCTest
@testable import SendGridTests

XCTMain([
    testCase(SendGridTests.allTests),
])

#endif
