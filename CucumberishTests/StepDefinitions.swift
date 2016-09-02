import Nimble
import KIF

class StepDefinitions: NSObject {
    func setup() {

        Given("I am on the master screen") {
            (args, userInfo) -> Void in
            self.tester().waitForViewWithAccessibilityLabel("Table")
        }

        And("an item is available") {
            (args, userInfo) -> Void in
            let tableView = self.getTableView()
            if tableView.cellForRowAtIndexPath(NSIndexPath.indexPathForFirstRow()) == nil {
                self.tapButton(withLabel:"Add")
            }
        }

        When("I tap the (.*)? button") {
            (args, userInfo) -> Void in
            self.tapButton(withLabel: args[0])
        }

        When("I tap the item") {
            (args, userInfo) -> Void in
            self.tester().tapRowAtIndexPath(NSIndexPath.indexPathForFirstRow(), inTableView: self.getTableView())
        }

        Then("an item is added") {
            (args, userInfo) -> Void in
            self.tester().waitForCellAtIndexPath(NSIndexPath.indexPathForFirstRow(), inTableView: self.getTableView())
        }

        Then("the detail screen is shown") {
            (args, userInfo) -> Void in
            self.tester().waitForViewWithAccessibilityLabel("Detail")
        }
    }

    private func getTableView() -> UITableView {
        return self.tester().waitForViewWithAccessibilityLabel("Table") as! UITableView
    }

    private func tapButton(withLabel label: String) {
        let buttonLabel = label.capitalizedString
        self.tester().tapViewWithAccessibilityLabel(buttonLabel)
    }

    private func tester(file: String = #file, _ line: Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
}
