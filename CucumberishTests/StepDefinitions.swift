import XCTest

class StepDefinitions: NSObject {
    class func setup() {
        Given("^a (foo)$") {(args, userInfo) -> Void in
            XCTAssertEqual(args[0], "foo")
        }

        When("^it is (bar)$") {(args, userInfo) -> Void in
            XCTAssertEqual(args[0], "bar")
        }

        Then("^(foobar)$") {(args, userInfo) -> Void in
            XCTAssertEqual(args[0], "foobar")
        }
    }
}
