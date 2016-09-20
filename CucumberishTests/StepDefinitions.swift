import Nimble
import KIF

class StepDefinitions: NSObject {
    func setup() {

        Given("I am on the master screen") {
            (args, userInfo) -> Void in
            self.tester().waitForView(withAccessibilityLabel: "Table")
        }

        And("an item is available") {
            (args, userInfo) -> Void in
            let tableView = self.getTableView()
            if tableView.cellForRow(at: IndexPath.indexPathForFirstRow()) == nil {
                self.tapButton(withLabel:"Add")
            }
        }

        When("I tap the (.*)? button") {
            (args, userInfo) -> Void in
            self.tapButton(withLabel: (args?[0])!)
        }

        When("I tap the item") {
            (args, userInfo) -> Void in
            self.tester().tapRow(at: IndexPath.indexPathForFirstRow(), in: self.getTableView())
        }

        Then("an item is added") {
            (args, userInfo) -> Void in
            self.tester().waitForCell(at: IndexPath.indexPathForFirstRow(), in: self.getTableView())
        }

        Then("the detail screen is shown") {
            (args, userInfo) -> Void in
            self.tester().waitForView(withAccessibilityLabel: "Detail")
        }
    }

    fileprivate func getTableView() -> UITableView {
        return self.tester().waitForView(withAccessibilityLabel: "Table") as! UITableView
    }

    fileprivate func tapButton(withLabel label: String) {
        let buttonLabel = label.capitalized
        self.tester().tapView(withAccessibilityLabel: buttonLabel)
    }

    fileprivate func tester(_ file: String = #file, _ line: Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
}
