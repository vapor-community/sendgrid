#if os(Linux)

import XCTest

@testable import MailClientProtocolTests
@testable import ConsoleMailClientTests
@testable import InMemoryMailClientTests

XCTMain([
    // MailClientProtocol Tests
    testCase(DropletTests.allTests),

    // ConsoleMailClientTests
    testCase(ConsoleMailClientTests.allTests),

    // InMemoryMailClientTests
    testCase(InMemoryMailClientTests.allTests),
])

#endif
