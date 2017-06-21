#if os(Linux)

import XCTest
@testable import SendGridProviderTests

XCTMain([
    testCase(SendGridProviderTests.allTests),
])

#endif
