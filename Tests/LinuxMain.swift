#if os(Linux)

import XCTest

@testable import MailClientProtocolTests
@testable import MailModelsTests
@testable import ConsoleMailClientTests
@testable import InMemoryMailClientTests

XCTMain([
    // MailClientProtocol Tests
    testCase(DropletTests.allTests),

    // Mail Models Tests
    testCase(EmailAddressTests.allTests),
    testCase(EmailAttachmentTests.allTests),
    testCase(EmailBodyTests.allTests),

    // ConsoleMailClientTests
    testCase(ConsoleMailClientTests.allTests),

    // InMemoryMailClientTests
    testCase(InMemoryMailClientTests.allTests),
])

#endif
