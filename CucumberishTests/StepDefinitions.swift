import Quick
import Nimble

class StepDefinitions: NSObject {
    class func setup() {
        Given("^a (foo)$") {(args, userInfo) -> Void in
            expect(args[0]).to(equal("foo"))
        }

        When("^it is (bar)$") {(args, userInfo) -> Void in
            expect(args[0]).to(equal("bar"))
        }

        Then("^(foobar)$") {(args, userInfo) -> Void in
            expect(args[0]).to(equal("foobar"))
        }
    }
}
